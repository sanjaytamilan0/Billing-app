const mongoose = require('mongoose');

const ocrDocumentSchema = new mongoose.Schema({
    imageUrl: {
        type: String,
        default: null
    },
    data: {
        type: mongoose.Schema.Types.Mixed, // Stores dynamic key-value pairs
        default: {}
    },
    rawText: {
        type: String,
        default: ''
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('OcrDocument', ocrDocumentSchema);
