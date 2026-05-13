const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    productCode: {
        type: String,
        required: true,
        unique: true
    },
    name: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    quantity: {
        type: Number,
        required: true,
        default: 0
    },
    category: {
        type: String,
        required: true
    },
    description: {
        type: String
    },
    companyName: {
        type: String,
        required: true
    },
    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    creatorRole: {
        type: String,
        required: true
    }
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);
