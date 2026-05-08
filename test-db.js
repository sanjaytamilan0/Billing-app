require('dotenv').config();
const mongoose = require('mongoose');

async function test() {
    try {
        console.log('Connecting...');
        await mongoose.connect(process.env.MONGO_URL);
        console.log('Connected!');
        
        // Try a simple operation
        const connection = mongoose.connection;
        const result = await connection.db.admin().command({ ping: 1 });
        console.log('Ping result:', result);
        
        process.exit(0);
    } catch (err) {
        console.error('Test failed:', err);
        process.exit(1);
    }
}

test();
