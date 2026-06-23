"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const cookie_parser_1 = __importDefault(require("cookie-parser"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const auth_1 = __importDefault(require("./routes/auth"));
const admin_1 = __importDefault(require("./routes/admin"));
const appointments_1 = __importDefault(require("./routes/appointments"));
const notifications_1 = __importDefault(require("./routes/notifications"));
const shops_1 = __importDefault(require("./routes/shops"));
const adminUsers_1 = __importDefault(require("./routes/adminUsers"));
const app = (0, express_1.default)();
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)({ origin: true, credentials: true }));
app.use(express_1.default.json());
app.use((0, cookie_parser_1.default)());
const limiter = (0, express_rate_limit_1.default)({
    windowMs: 1 * 60 * 1000,
    max: 100
});
app.use(limiter);
app.use('/auth', auth_1.default);
app.use('/admin', admin_1.default);
app.use('/appointments', appointments_1.default);
app.use('/notifications', notifications_1.default);
app.use('/shops', shops_1.default);
app.use('/admin', adminUsers_1.default);
app.get('/', (req, res) => res.json({ ok: true }));
exports.default = app;
