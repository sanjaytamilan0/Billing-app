require('dotenv').config();
const mongoose = require('mongoose');
const Order = require('./models/Order');

async function test() {
    await mongoose.connect(process.env.MONGO_URL);
    console.log("Connected");
    
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const res = await Order.aggregate([
        { 
            $match: { 
                createdAt: { $gte: sevenDaysAgo },
                status: { $in: ['paid', 'approved', 'completed'] }
            } 
        },
        {
            $group: {
                _id: { $dateToString: { format: "%Y-%m-%d", date: "$createdAt" } },
                revenue: { $sum: '$totalAmount' }
            }
        },
        { $sort: { _id: 1 } }
    ]);
    console.log("Daily Revenue Aggregation:", JSON.stringify(res, null, 2));

    const totalOrders = await Order.find({});
    console.log("All orders count:", totalOrders.length);
    if(totalOrders.length > 0) {
        console.log("First order createdAt:", totalOrders[0].createdAt, "status:", totalOrders[0].status, "amount:", totalOrders[0].totalAmount);
    }
    
    process.exit(0);
}
test();
