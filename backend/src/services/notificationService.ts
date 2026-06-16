import axios from 'axios';
import admin from 'firebase-admin';

let firebaseInitialized = false;

function tryInitFirebase() {
  if (firebaseInitialized) return;
  const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
  const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  try {
    const adm: any = admin;
    if (serviceAccountJson) {
      const obj = JSON.parse(serviceAccountJson);
      adm.initializeApp({ credential: adm.credential.cert(obj) });
      firebaseInitialized = true;
      console.log('Initialized firebase-admin from JSON env var');
      return;
    }
    if (serviceAccountPath) {
      const obj = require(serviceAccountPath);
      adm.initializeApp({ credential: adm.credential.cert(obj) });
      firebaseInitialized = true;
      console.log('Initialized firebase-admin from file path');
      return;
    }
  } catch (err: any) {
    console.warn('Failed to initialize firebase-admin:', err?.message || err);
  }
}

const FCM_URL = 'https://fcm.googleapis.com/fcm/send';
const SERVER_KEY = process.env.FCM_SERVER_KEY || '';

export async function sendPushToToken(token: string, title: string, body: string, data?: any) {
  tryInitFirebase();
    if (firebaseInitialized) {
    try {
      const adm: any = admin;
      const message: any = {
        token,
        notification: { title, body },
        data: data || undefined
      };
      await adm.messaging().send(message);
      return;
    } catch (err) {
      console.error('firebase-admin send failed, falling back to legacy FCM:', err);
      // fallthrough to legacy
    }
  }

  if (!SERVER_KEY) {
    console.warn('FCM_SERVER_KEY not set and firebase-admin not initialized; skipping push');
    return;
  }

  try {
    const payload: any = {
      to: token,
      notification: { title, body },
      data: data || {}
    };
    await axios.post(FCM_URL, payload, { headers: { Authorization: `key=${SERVER_KEY}`, 'Content-Type': 'application/json' } });
  } catch (err) {
    console.error('Failed to send push via legacy FCM', err);
  }
}
