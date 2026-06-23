"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.listOwnerApplications = listOwnerApplications;
exports.approveApplication = approveApplication;
exports.rejectApplication = rejectApplication;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function listOwnerApplications(req, res) {
    try {
        const owners = await prisma.owner.findMany({
            where: {},
            include: { user: true, shop: true }
        });
        const payload = owners.map(o => ({
            id: o.userId,
            fullName: o.fullName,
            phone: o.phone,
            status: o.status,
            shop: o.shop ? { id: o.shop.id, name: o.shop.name, address: o.shop.address, city: o.shop.city, district: o.shop.district } : null,
            createdAt: o.user.createdAt
        }));
        res.json(payload);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function approveApplication(req, res) {
    try {
        const id = req.params.id; // userId
        const owner = await prisma.owner.findUnique({ where: { userId: id } });
        if (!owner)
            return res.status(404).json({ message: 'Owner not found' });
        await prisma.owner.update({ where: { userId: id }, data: { status: 'APPROVED' } });
        // create notification
        await prisma.notification.create({ data: { userId: id, title: 'Application Approved', body: 'Your owner application has been approved.' } });
        // send push to registered device tokens
        const tokens = await prisma.deviceToken.findMany({ where: { userId: id } });
        for (const t of tokens) {
            // lazy require to avoid adding heavy deps at module top
            const { sendPushToToken } = await Promise.resolve().then(() => __importStar(require('../services/notificationService')));
            sendPushToToken(t.token, 'Application Approved', 'Your owner application has been approved.');
        }
        res.json({ message: 'Owner approved' });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function rejectApplication(req, res) {
    try {
        const id = req.params.id; // userId
        const owner = await prisma.owner.findUnique({ where: { userId: id } });
        if (!owner)
            return res.status(404).json({ message: 'Owner not found' });
        await prisma.owner.update({ where: { userId: id }, data: { status: 'REJECTED' } });
        await prisma.notification.create({ data: { userId: id, title: 'Application Rejected', body: 'Your owner application has been rejected.' } });
        const tokens = await prisma.deviceToken.findMany({ where: { userId: id } });
        for (const t of tokens) {
            const { sendPushToToken } = await Promise.resolve().then(() => __importStar(require('../services/notificationService')));
            sendPushToToken(t.token, 'Application Rejected', 'Your owner application has been rejected.');
        }
        res.json({ message: 'Owner rejected' });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
