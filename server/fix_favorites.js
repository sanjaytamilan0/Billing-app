const mongoose = require('mongoose');
const User = require('./models/User');
mongoose.connect('mongodb://127.0.0.1:27017/billing_app', { useNewUrlParser: true, useUnifiedTopology: true })
.then(async () => {
    const user = await User.findOne({});
    console.log("Favorites:", user.favorites);
    process.exit(0);
});
