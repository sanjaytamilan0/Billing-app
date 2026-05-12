const jwt = require('jsonwebtoken');
const User = require('../models/User');

module.exports = async (req, res, next) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
        
        // Verify token in database
        const user = await User.findOne({ _id: decodedToken.userId, token: token });
        if (!user) {
            throw new Error();
        }

        req.userData = { userId: decodedToken.userId, role: decodedToken.role };
        req.user = user; // Attach the full user object
        next();
    } catch (error) {
        return res.status(401).json({
            message: 'Auth failed'
        });
    }
};
