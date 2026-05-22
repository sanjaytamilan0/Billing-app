const mongoose = require('mongoose');
const User = require('./models/User');
const Product = require('./models/Product'); // Ensure Product is required!

mongoose.connect('mongodb://127.0.0.1:27017/billing_app')
.then(async () => {
    const user = await User.findOne({}).populate('favorites');
    console.log("Valid Favorites:");
    const validFavorites = user.favorites.filter(f => f && typeof f === 'object' && f._id);
    console.log(JSON.stringify(validFavorites));
    process.exit(0);
});
