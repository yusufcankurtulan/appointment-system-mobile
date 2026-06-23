"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.listUsers = listUsers;
exports.disableUser = disableUser;
exports.enableUser = enableUser;
exports.deleteUser = deleteUser;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function listUsers(req, res) {
    try {
        const users = await prisma.user.findMany({ select: { id: true, email: true, role: true, createdAt: true, disabled: true } });
        res.json(users);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function disableUser(req, res) {
    try {
        const id = req.params.id;
        await prisma.user.update({ where: { id }, data: { disabled: true } });
        res.json({ message: 'User disabled' });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function enableUser(req, res) {
    try {
        const id = req.params.id;
        await prisma.user.update({ where: { id }, data: { disabled: false } });
        res.json({ message: 'User enabled' });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function deleteUser(req, res) {
    try {
        const id = req.params.id;
        await prisma.user.delete({ where: { id } });
        res.json({ message: 'User deleted' });
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
