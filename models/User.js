const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    phone: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    role: {
        type: String,
        required: true
    },
    companyName: {
        type: String,
        required: true
    }
});

module.exports = mongoose.model('User', userSchema);
