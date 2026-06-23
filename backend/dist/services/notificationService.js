"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendPushToToken = sendPushToToken;
const axios_1 = __importDefault(require("axios"));
const firebase_admin_1 = __importDefault(require("firebase-admin"));
let firebaseInitialized = false;
function tryInitFirebase() {
    if (firebaseInitialized)
        return;
    const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
    const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
    try {
        const adm = firebase_admin_1.default;
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
    }
    catch (err) {
        console.warn('Failed to initialize firebase-admin:', err?.message || err);
    }
}
const FCM_URL = 'https://fcm.googleapis.com/fcm/send';
const SERVER_KEY = process.env.FCM_SERVER_KEY || '';
async function sendPushToToken(token, title, body, data) {
    tryInitFirebase();
    if (firebaseInitialized) {
        try {
            const adm = firebase_admin_1.default;
            const message = {
                token,
                notification: { title, body },
                data: data || undefined
            };
            await adm.messaging().send(message);
            return;
        }
        catch (err) {
            console.error('firebase-admin send failed, falling back to legacy FCM:', err);
            // fallthrough to legacy
        }
    }
    if (!SERVER_KEY) {
        console.warn('FCM_SERVER_KEY not set and firebase-admin not initialized; skipping push');
        return;
    }
    try {
        const payload = {
            to: token,
            notification: { title, body },
            data: data || {}
        };
        await axios_1.default.post(FCM_URL, payload, { headers: { Authorization: `key=${SERVER_KEY}`, 'Content-Type': 'application/json' } });
    }
    catch (err) {
        console.error('Failed to send push via legacy FCM', err);
    }
}
