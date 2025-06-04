const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, enum: ['conductor', 'dueno'], default: 'conductor' }
});

module.exports = mongoose.models.User || mongoose.model('User', userSchema);

