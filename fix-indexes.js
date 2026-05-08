require('dotenv').config();
const mongoose = require('mongoose');

async function fixIndexes() {
    try {
        console.log('Connecting...');
        await mongoose.connect(process.env.MONGO_URL);
        console.log('Connected!');
        
        const connection = mongoose.connection;
        console.log('Dropping all indexes on users collection...');
        await connection.collection('users').dropIndexes();
        console.log('Indexes dropped successfully! Mongoose will recreate the correct ones on next run.');
        
        process.exit(0);
    } catch (err) {
        console.error('Failed to drop indexes:', err);
        process.exit(1);
    }
}

fixIndexes();
