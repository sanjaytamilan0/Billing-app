require('dotenv').config();
const aiService = require('./services/aiService');
const User = require('./models/User');
const mongoose = require('mongoose');

mongoose.connect('mongodb://127.0.0.1:27017/billing_app')
.then(async () => {
    try {
        const user = await User.findOne({});
        console.log("User:", user.phone);
        const reply = await aiService.processChat(user, "Hello");
        console.log("Reply:", reply);
    } catch(e) {
        console.error("TEST ERROR:", e);
    }
    process.exit(0);
});
