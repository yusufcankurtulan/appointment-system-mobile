"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.verifyAccessToken = verifyAccessToken;
exports.requireRole = requireRole;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
function verifyAccessToken(req, res, next) {
    const auth = req.headers.authorization;
    if (!auth)
        return res.status(401).json({ message: 'No authorization header' });
    const parts = auth.split(' ');
    if (parts.length !== 2 || parts[0] !== 'Bearer')
        return res.status(401).json({ message: 'Invalid authorization header' });
    const token = parts[1];
    jsonwebtoken_1.default.verify(token, process.env.JWT_ACCESS_SECRET || 'secret', (err, decoded) => {
        if (err)
            return res.status(401).json({ message: 'Invalid token' });
        req.user = decoded;
        next();
    });
}
function requireRole(role) {
    return (req, res, next) => {
        const user = req.user;
        if (!user)
            return res.status(401).json({ message: 'Unauthorized' });
        if (user.role !== role)
            return res.status(403).json({ message: 'Forbidden' });
        next();
    };
}
