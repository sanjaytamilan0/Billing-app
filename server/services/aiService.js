const { GoogleGenerativeAI } = require('@google/generative-ai');
const Product = require('../models/Product');
const Cart = require('../models/Cart');
const Order = require('../models/Order');
const ProductSuggestion = require('../models/ProductSuggestion');
const User = require('../models/User');

async function processChat(user, prompt) {
    if (!process.env.GEMINI_API_KEY) {
        throw new Error('GEMINI_API_KEY is not set. Please add it to your .env file.');
    }

    const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

    const availableTools = [];

    // Base tools for all users
    const baseTools = {
        functionDeclarations: [
            {
                name: "searchProducts",
                description: "Search for products in the current company's inventory by name or category. Use this to find a product ID before adding it to the cart.",
                parameters: {
                    type: "OBJECT",
                    properties: {
                        query: { type: "STRING", description: "Search query (e.g., 'Latte', 'Coffee')" }
                    },
                    required: ["query"]
                }
            },
            {
                name: "addToCart",
                description: "Add a specific product to the user's cart.",
                parameters: {
                    type: "OBJECT",
                    properties: {
                        productId: { type: "STRING", description: "The exact MongoDB ObjectId of the product" },
                        quantity: { type: "INTEGER", description: "Number of items to add" }
                    },
                    required: ["productId", "quantity"]
                }
            },
            {
                name: "checkout",
                description: "Checkout the current cart and place an order.",
            },
            {
                name: "suggestProduct",
                description: "Suggest a new product to be added to the catalog.",
                parameters: {
                    type: "OBJECT",
                    properties: {
                        name: { type: "STRING" },
                        description: { type: "STRING" },
                        category: { type: "STRING" },
                        reason: { type: "STRING" }
                    },
                    required: ["name", "category"]
                }
            }
        ]
    };
    
    availableTools.push(baseTools);

    // If staff or owner, they can add products
    if (user.role === 'staff' || user.role === 'owner') {
        const staffTools = {
            functionDeclarations: [
                {
                    name: "addProduct",
                    description: "Directly add a new product to the inventory. Staff/owners only.",
                    parameters: {
                        type: "OBJECT",
                        properties: {
                            productCode: { type: "STRING" },
                            name: { type: "STRING" },
                            price: { type: "NUMBER" },
                            quantity: { type: "INTEGER" },
                            category: { type: "STRING" },
                            description: { type: "STRING" }
                        },
                        required: ["productCode", "name", "price", "quantity", "category"]
                    }
                }
            ]
        };
        availableTools.push(staffTools);
    }

    const systemInstruction = `You are a helpful voice and text assistant for the Billing App.
The user's name is ${user.phone}. Their role is ${user.role}. Company: ${user.companyName}.
You must assist them with managing their shopping cart, placing orders, and finding products.
If they ask to add a product to the cart, FIRST use searchProducts to find the productId, then use addToCart.
When you finish an action, give a brief, friendly natural language response (1-2 short sentences) because it will be spoken out loud by text-to-speech.
DO NOT use markdown formatting in your response. Keep it conversational.`;

    const model = genAI.getGenerativeModel({
        model: 'gemini-2.5-flash',
        systemInstruction: systemInstruction,
        tools: availableTools,
    });

    const chat = model.startChat();

    let response = await chat.sendMessage(prompt);
    let functionCalls = response.response.functionCalls();
    
    // Process function calls if the model wants to call tools
    while (functionCalls && functionCalls.length > 0) {
        const toolResults = [];
        
        for (const call of functionCalls) {
            const name = call.name;
            const args = call.args;
            let result;
            
            try {
                if (name === 'searchProducts') {
                    const products = await Product.find({
                        companyName: user.companyName,
                        $or: [
                            { name: { $regex: args.query, $options: 'i' } },
                            { category: { $regex: args.query, $options: 'i' } }
                        ]
                    }).limit(5).select('_id name price quantity category');
                    result = { success: true, products };
                } 
                else if (name === 'addToCart') {
                    const product = await Product.findById(args.productId);
                    if (!product) throw new Error('Product not found');
                    if (product.quantity < args.quantity) throw new Error(`Only ${product.quantity} left in stock`);
                    
                    let cart = await Cart.findOne({ userId: user._id });
                    if (!cart) {
                        cart = new Cart({ userId: user._id, companyName: user.companyName, items: [] });
                    }
                    const itemIndex = cart.items.findIndex(p => p.productId.toString() === args.productId);
                    if (itemIndex > -1) {
                        cart.items[itemIndex].quantity += args.quantity;
                    } else {
                        cart.items.push({
                            productId: product._id,
                            name: product.name,
                            price: product.price,
                            quantity: args.quantity
                        });
                    }
                    await cart.save();
                    result = { success: true, message: `Added ${args.quantity} ${product.name} to cart` };
                }
                else if (name === 'checkout') {
                    const cart = await Cart.findOne({ userId: user._id });
                    if (!cart || cart.items.length === 0) throw new Error('Cart is empty');
                    
                    let totalAmount = 0;
                    for (let item of cart.items) {
                        const product = await Product.findById(item.productId);
                        if (!product || product.quantity < item.quantity) {
                            throw new Error(`Stock issue for ${item.name}. Available: ${product ? product.quantity : 0}, Required: ${item.quantity}`);
                        }
                        product.quantity -= item.quantity;
                        await product.save();
                        totalAmount += (item.price * item.quantity);
                    }
                    
                    const order = new Order({
                        userId: user._id,
                        userRole: user.role,
                        companyName: user.companyName,
                        items: cart.items,
                        totalAmount,
                        status: 'paid'
                    });
                    await order.save();
                    await Cart.findOneAndDelete({ userId: user._id });
                    result = { success: true, orderId: order._id, total: totalAmount };
                }
                else if (name === 'suggestProduct') {
                    const suggestion = new ProductSuggestion({
                        name: args.name,
                        description: args.description || '',
                        category: args.category,
                        suggestedBy: user._id,
                        companyName: user.companyName,
                        status: 'pending'
                    });
                    await suggestion.save();
                    result = { success: true, message: "Suggestion submitted successfully" };
                }
                else if (name === 'addProduct') {
                    if (user.role !== 'staff' && user.role !== 'owner') throw new Error('Unauthorized');
                    const product = new Product({
                        productCode: args.productCode,
                        name: args.name,
                        price: args.price,
                        quantity: args.quantity,
                        category: args.category,
                        description: args.description || '',
                        companyName: user.companyName,
                        createdBy: user._id,
                        creatorRole: user.role
                    });
                    await product.save();
                    result = { success: true, message: "Product created", productId: product._id };
                }
                else {
                    result = { error: "Unknown tool" };
                }
            } catch (err) {
                console.error("AI Tool Error:", err); result = { error: err.message };
            }
            
            toolResults.push({
                functionResponse: {
                    name: call.name,
                    response: result
                }
            });
        }
        
        response = await chat.sendMessage(toolResults);
        functionCalls = response.response.functionCalls();
    }

    return response.response.text();
}

module.exports = { processChat };
