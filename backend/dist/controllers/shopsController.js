"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getNearby = getNearby;
exports.getShopById = getShopById;
exports.searchShops = searchShops;
exports.addShopImage = addShopImage;
exports.getChairs = getChairs;
exports.createChair = createChair;
exports.uploadShopImage = uploadShopImage;
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
function haversineDistance(lat1, lon1, lat2, lon2) {
    const toRad = (v) => (v * Math.PI) / 180;
    const R = 6371; // km
    const dLat = toRad(lat2 - lat1);
    const dLon = toRad(lon2 - lon1);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}
async function getNearby(req, res) {
    try {
        const lat = parseFloat(req.query.lat);
        const lng = parseFloat(req.query.lng);
        const radiusKm = parseFloat(req.query.radius || '10');
        if (Number.isNaN(lat) || Number.isNaN(lng))
            return res.status(400).json({ message: 'lat & lng required' });
        const deltaLat = radiusKm / 111; // approx
        const deltaLon = radiusKm / (111 * Math.cos(lat * Math.PI / 180));
        const minLat = lat - deltaLat;
        const maxLat = lat + deltaLat;
        const minLon = lng - deltaLon;
        const maxLon = lng + deltaLon;
        const candidates = await prisma.shop.findMany({ where: { latitude: { gte: minLat, lte: maxLat }, longitude: { gte: minLon, lte: maxLon } }, include: { images: true, chairs: true } });
        const results = candidates.map(s => ({ shop: s, distance: haversineDistance(lat, lng, s.latitude || 0, s.longitude || 0) })).filter(r => r.distance <= radiusKm).sort((a, b) => a.distance - b.distance);
        res.json(results.map(r => ({ id: r.shop.id, name: r.shop.name, description: r.shop.description, city: r.shop.city, district: r.shop.district, address: r.shop.address, distanceKm: r.distance, images: r.shop.images })));
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function getShopById(req, res) {
    try {
        const id = req.params.id;
        const shop = await prisma.shop.findUnique({ where: { id }, include: { images: true, chairs: true, owner: true } });
        if (!shop)
            return res.status(404).json({ message: 'Shop not found' });
        res.json(shop);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function searchShops(req, res) {
    try {
        const { city, district, name } = req.query;
        const where = {};
        if (city)
            where.city = { equals: city };
        if (district)
            where.district = { equals: district };
        if (name)
            where.name = { contains: name, mode: 'insensitive' };
        const shops = await prisma.shop.findMany({ where, include: { images: true, chairs: true } });
        res.json(shops);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function addShopImage(req, res) {
    try {
        const user = req.user;
        const shopId = req.params.id;
        const { url, alt } = req.body;
        if (!url)
            return res.status(400).json({ message: 'url required' });
        const shop = await prisma.shop.findUnique({ where: { id: shopId } });
        if (!shop)
            return res.status(404).json({ message: 'Shop not found' });
        if (shop.ownerId !== user.userId && user.role !== 'ADMIN')
            return res.status(403).json({ message: 'Forbidden' });
        const img = await prisma.shopImage.create({ data: { shopId, url, alt } });
        res.json(img);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function getChairs(req, res) {
    try {
        const shopId = req.params.id;
        const chairs = await prisma.chair.findMany({ where: { shopId } });
        res.json(chairs);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function createChair(req, res) {
    try {
        const user = req.user;
        const shopId = req.params.id;
        const { name, bio } = req.body;
        if (!name)
            return res.status(400).json({ message: 'name required' });
        const shop = await prisma.shop.findUnique({ where: { id: shopId } });
        if (!shop)
            return res.status(404).json({ message: 'Shop not found' });
        if (shop.ownerId !== user.userId && user.role !== 'ADMIN')
            return res.status(403).json({ message: 'Forbidden' });
        const chair = await prisma.chair.create({ data: { shopId, name, bio } });
        res.json(chair);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
async function uploadShopImage(req, res) {
    try {
        const user = req.user;
        const shopId = req.params.id;
        const { imageBase64, alt } = req.body;
        if (!imageBase64)
            return res.status(400).json({ message: 'imageBase64 required' });
        const shop = await prisma.shop.findUnique({ where: { id: shopId } });
        if (!shop)
            return res.status(404).json({ message: 'Shop not found' });
        if (shop.ownerId !== user.userId && user.role !== 'ADMIN')
            return res.status(403).json({ message: 'Forbidden' });
        // upload to Cloudinary if configured
        const cloudinaryUrl = process.env.CLOUDINARY_URL;
        let url = '';
        if (cloudinaryUrl) {
            const cloudinary = require('cloudinary').v2;
            if (!cloudinary.config().api_key) {
                cloudinary.config({ cloud_name: process.env.CLOUDINARY_CLOUD_NAME, api_key: process.env.CLOUDINARY_API_KEY, api_secret: process.env.CLOUDINARY_API_SECRET });
            }
            const result = await cloudinary.uploader.upload(`data:image/jpeg;base64,${imageBase64}`, { folder: `shops/${shopId}` });
            url = result.secure_url;
        }
        else {
            return res.status(500).json({ message: 'Cloudinary not configured' });
        }
        const img = await prisma.shopImage.create({ data: { shopId, url, alt } });
        res.json(img);
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
}
