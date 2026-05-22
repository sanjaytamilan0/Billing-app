require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const User = require('./models/User');
const Note = require('./models/Note');
const Product = require('./models/Product');
const ProductSuggestion = require('./models/ProductSuggestion');
const Category = require('./models/Category');
const Cart = require('./models/Cart');
const Order = require('./models/Order');
const auth = require('./middleware/auth');

const path = require('path');

const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});
const Message = require('./models/Message');

const PORT = process.env.PORT || 10000;

app.get('/hello', (req, res) => res.send('world'));

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/ping', (req, res) => res.send('pong'));

app.get('/', (req, res) => {
    console.log('Request for root / received');
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Database Connection
mongoose.connect(process.env.MONGO_URL)
    .then(async () => {
        console.log('Connected to MongoDB');
        // Clean up old indexes if they exist
        try {
            await mongoose.connection.collections['users'].dropIndexes();
            console.log('Old indexes cleaned up');
        } catch (e) {
            console.log('No old indexes to clean or already cleaned');
        }
    })
    .catch(err => console.error('Could not connect to MongoDB', err));

// --- Public APIs (No Auth) ---

// 1. Basic Testing API
app.get('/', (req, res) => {
    res.json({ message: 'Note API is working!' });
});

// 2. List all unique roles in the system
app.get('/api/public/roles', async (req, res) => {
    try {
        const roles = await User.distinct('role');
        res.status(200).json(roles);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 2a. List all unique company names from owners
app.get('/api/public/companies', async (req, res) => {
    try {
        const companies = await User.find({ role: 'owner' }).distinct('companyName');
        res.status(200).json(companies);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 3. Register API
app.post('/api/register', async (req, res) => {
    try {
        const { phone, password, role, companyName } = req.body;
        
        // Allowed roles for registration
        const allowedRoles = ['super_admin', 'owner', 'user'];
        if (!allowedRoles.includes(role)) {
            return res.status(400).json({ 
                message: 'Invalid role. Only super_admin, owner, and user are allowed to register.' 
            });
        }

        const user = new User({ 
            phone, 
            password, 
            role, 
            companyName,
            permissions: [] // Initialize with empty list
        });
        await user.save();
        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 3. Login API
app.post('/api/login', async (req, res) => {
    try {
        const { phone, password, role } = req.body;
        const user = await User.findOne({ phone, password, role });
        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials or role' });
        }
        const token = jwt.sign(
            { userId: user._id, role: user.role },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );
        user.token = token;
        await user.save();
        res.status(200).json({ 
            token, 
            userId: user._id, 
            role: user.role,
            companyName: user.companyName,
            permissions: user.permissions || [] 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- Chat APIs ---

// 1. Get Chat History between current user and another user
app.get('/api/chat/history/:otherUserId', auth, async (req, res) => {
    try {
        const userId = req.user._id;
        const { otherUserId } = req.params;

        const messages = await Message.find({
            $or: [
                { sender: userId, receiver: otherUserId },
                { sender: otherUserId, receiver: userId }
            ]
        }).sort({ createdAt: 1 });

        res.status(200).json(messages);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 2. Get list of chat participants (For Owner to see all staff and users in company)
app.get('/api/chat/participants', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        if (currentUser.role !== 'owner' && currentUser.role !== 'super_admin') {
            return res.status(403).json({ message: 'Only owners can see participant list' });
        }

        const participants = await User.find({ 
            companyName: currentUser.companyName,
            _id: { $ne: currentUser._id },
            role: { $in: ['staff', 'user'] }
        }).select('phone role companyName');

        res.status(200).json(participants);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 3. Get Owner for the current company (For Staff/User to find who to talk to)
app.get('/api/chat/owner', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        const owner = await User.findOne({ 
            companyName: currentUser.companyName, 
            role: 'owner' 
        }).select('phone role companyName');

        if (!owner) return res.status(404).json({ message: 'Owner not found for this company' });
        res.status(200).json(owner);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// 4. Get Current User Profile
app.get('/api/me', auth, async (req, res) => {
    try {
        const user = await User.findById(req.user._id).select('-password -token');
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 4a. Update User Company (For choosing a shop)
app.put('/api/users/company', auth, async (req, res) => {
    try {
        const { companyName } = req.body;
        const user = await User.findById(req.user._id);
        if (!user) return res.status(404).json({ message: 'User not found' });

        user.companyName = companyName;
        await user.save();

        // Clear user's cart when they switch companies
        await Cart.deleteMany({ userId: req.user._id });

        res.status(200).json({ message: 'Company updated and cart cleared', user });
    } catch (error) {
        console.error('Update Company Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// 5. Update Current User Role
app.post('/api/user/role', auth, async (req, res) => {
    try {
        const { role } = req.body;
        const user = await User.findById(req.userData.userId);
        if (!user) return res.status(404).json({ message: 'User not found' });
        
        user.role = role;
        await user.save();
        res.status(200).json({ message: 'Role updated successfully', role: user.role });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 5. Get Users List (Role-based)
app.get('/api/users', auth, async (req, res) => {
    try {
        let query = {};
        const currentUser = req.user;

        if (currentUser.role === 'super_admin') {
            query = {};
        } else if (currentUser.role === 'owner') {
            query = { companyName: currentUser.companyName };
        } else {
            return res.status(403).json({ message: 'Access denied: Insufficient permissions' });
        }

        const users = await User.find(query).select('-password -token');
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- Staff Management APIs (Owner/Super_Admin only) ---

// 6. Create Staff
app.post('/api/staff', auth, async (req, res) => {
    try {
        const { phone, password, companyName } = req.body;
        const currentUser = req.user;

        // Only super_admin or owner can create staff
        if (currentUser.role !== 'super_admin' && currentUser.role !== 'owner') {
            return res.status(403).json({ message: 'Access denied: Only owners can create staff' });
        }

        const staff = new User({
            phone,
            password,
            role: 'staff',
            // If super_admin, use companyName from body; if owner, use their own companyName
            companyName: currentUser.role === 'super_admin' ? companyName : currentUser.companyName,
            permissions: []
        });

        await staff.save();
        res.status(201).json({ message: 'Staff created successfully', staff });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 7. Update Staff
app.put('/api/staff/:id', auth, async (req, res) => {
    try {
        const { phone, role, companyName, permissions } = req.body;
        const currentUser = req.user;
        const staffId = req.params.id;

        const staff = await User.findById(staffId);
        if (!staff) return res.status(404).json({ message: 'Staff not found' });

        // Authorization check: Must be super_admin OR the owner of the same company
        if (currentUser.role !== 'super_admin' && 
           (currentUser.role !== 'owner' || currentUser.companyName !== staff.companyName)) {
            return res.status(403).json({ message: 'Access denied' });
        }

        if (phone) staff.phone = phone;
        if (role) staff.role = role;
        if (companyName && currentUser.role === 'super_admin') staff.companyName = companyName;
        if (permissions) staff.permissions = permissions;

        await staff.save();
        res.status(200).json({ message: 'Staff updated successfully', staff });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 8. Delete Staff
app.delete('/api/staff/:id', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        const staffId = req.params.id;

        const staff = await User.findById(staffId);
        if (!staff) return res.status(404).json({ message: 'Staff not found' });

        // Authorization check: Must be super_admin OR the owner of the same company
        if (currentUser.role !== 'super_admin' && 
           (currentUser.role !== 'owner' || currentUser.companyName !== staff.companyName)) {
            return res.status(403).json({ message: 'Access denied' });
        }

        await User.findByIdAndDelete(staffId);
        res.status(200).json({ message: 'Staff deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 9. Create Note API
app.post('/api/notes', auth, async (req, res) => {
    try {
        const { title, content } = req.body;
        const note = new Note({
            title,
            content,
            userId: req.userData.userId
        });
        await note.save();
        res.status(201).json(note);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 5. Get Notes API (Protected)
app.get('/api/notes', auth, async (req, res) => {
    try {
        const notes = await Note.find({ userId: req.userData.userId });
        res.status(200).json(notes);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- Product Management APIs ---

// 10. Create Product (Owner/Staff only)
app.post('/api/products', auth, async (req, res) => {
    try {
        const { name, price, category, description, quantity } = req.body;
        const currentUser = req.user;

        // Only super_admin, owner, or staff can create products
        if (!['super_admin', 'owner', 'staff'].includes(currentUser.role)) {
            return res.status(403).json({ message: 'Access denied' });
        }

        // Generate unique 16-character product code
        const productCode = Math.random().toString(36).substring(2, 10).toUpperCase() + 
                            Math.random().toString(36).substring(2, 10).toUpperCase();

        const product = new Product({
            productCode,
            name,
            price,
            quantity: quantity || 0,
            category,
            description,
            companyName: currentUser.companyName,
            createdBy: currentUser._id,
            creatorRole: currentUser.role
        });

        await product.save();
        res.status(201).json({ message: 'Product created successfully', product });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 10a. Update Product Quantity (Owner/Staff only)
app.patch('/api/products/:id/quantity', auth, async (req, res) => {
    try {
        const { quantity } = req.body;
        const currentUser = req.user;
        const productId = req.params.id;

        // Only owner or staff can update quantity
        if (!['owner', 'staff', 'super_admin'].includes(currentUser.role)) {
            return res.status(403).json({ message: 'Access denied. Only Owners and Staff can update quantity.' });
        }

        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }

        // Ensure they belong to the same company (except super_admin)
        if (currentUser.role !== 'super_admin' && product.companyName !== currentUser.companyName) {
            return res.status(403).json({ message: 'Access denied. Product belongs to another company.' });
        }

        product.quantity = quantity;
        await product.save();

        res.status(200).json({ message: 'Quantity updated successfully', product });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 11. Get Product by Code (For scanning)
app.get('/api/products/code/:code', auth, async (req, res) => {
    try {
        const product = await Product.findOne({ productCode: req.params.code });
        if (!product) return res.status(404).json({ message: 'Product not found' });
        
        // Ensure user belongs to the same company
        if (req.user.role !== 'super_admin' && req.user.companyName !== product.companyName) {
            return res.status(403).json({ message: 'Access denied' });
        }

        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 11a. Get AI-Driven Recommendations
app.get('/api/products/recommendations', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        const companyName = currentUser.companyName;

        let orderQuery = { companyName };
        if (currentUser.role === 'user') {
            orderQuery.userId = currentUser._id;
        }

        const recentOrders = await Order.find(orderQuery)
            .sort({ createdAt: -1 })
            .limit(10);

        let categoryCounts = {};
        let purchasedProductIds = new Set();

        recentOrders.forEach(order => {
            order.items.forEach(item => {
                if (item.productId) purchasedProductIds.add(item.productId.toString());
            });
        });

        if (purchasedProductIds.size > 0) {
            const purchasedProducts = await Product.find({ _id: { $in: Array.from(purchasedProductIds) } });
            purchasedProducts.forEach(product => {
                if (product.category) {
                    categoryCounts[product.category] = (categoryCounts[product.category] || 0) + 1;
                }
            });
        }

        const topCategories = Object.keys(categoryCounts).sort((a, b) => categoryCounts[b] - categoryCounts[a]);
        let recommendations = [];

        if (topCategories.length > 0) {
            recommendations = await Product.find({
                companyName: companyName,
                category: { $in: topCategories.slice(0, 3) }
            })
            .sort({ quantity: -1 })
            .limit(5)
            .populate('createdBy', 'phone role');
        }

        // Fallback
        if (recommendations.length === 0) {
            recommendations = await Product.find({ companyName: companyName })
                .sort({ quantity: -1, createdAt: -1 })
                .limit(5)
                .populate('createdBy', 'phone role');
        }

        res.status(200).json(recommendations);
    } catch (error) {
        console.error('Recommendations Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// 12. List Products (Role-based)
app.get('/api/products', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        let query = {};

        if (currentUser.role === 'super_admin') {
            query = {};
        } else {
            // owner, staff, and user only see products from their company
            query = { companyName: currentUser.companyName };
        }

        const products = await Product.find(query).populate('createdBy', 'phone role');
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- Product Suggestion APIs ---

// 12b. Create a product suggestion (Users)
app.post('/api/suggestions', auth, async (req, res) => {
    try {
        const { name, category, description, price } = req.body;
        const currentUser = req.user;

        const suggestion = new ProductSuggestion({
            name,
            category,
            description,
            price: price || 0,
            companyName: currentUser.companyName,
            suggestedBy: currentUser._id
        });

        await suggestion.save();
        res.status(201).json({ message: 'Suggestion submitted successfully', suggestion });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 12c. Get pending suggestions (Owner/Staff)
app.get('/api/suggestions', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        if (!['super_admin', 'owner', 'staff'].includes(currentUser.role)) {
            return res.status(403).json({ message: 'Access denied' });
        }

        let query = { status: 'pending' };
        if (currentUser.role !== 'super_admin') {
            query.companyName = currentUser.companyName;
        }

        const suggestions = await ProductSuggestion.find(query).populate('suggestedBy', 'phone role');
        res.status(200).json(suggestions);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 12d. Update suggestion details (Owner/Staff)
app.put('/api/suggestions/:id', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        if (!['super_admin', 'owner', 'staff'].includes(currentUser.role)) {
            return res.status(403).json({ message: 'Access denied' });
        }

        const suggestion = await ProductSuggestion.findById(req.params.id);
        if (!suggestion) return res.status(404).json({ message: 'Suggestion not found' });

        if (currentUser.role !== 'super_admin' && suggestion.companyName !== currentUser.companyName) {
            return res.status(403).json({ message: 'Access denied' });
        }

        const { name, category, description, price } = req.body;
        if (name) suggestion.name = name;
        if (category) suggestion.category = category;
        if (description) suggestion.description = description;
        if (price !== undefined) suggestion.price = price;

        await suggestion.save();
        res.status(200).json({ message: 'Suggestion updated', suggestion });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 12e. Accept/Reject suggestion (Owner/Staff)
app.patch('/api/suggestions/:id/status', auth, async (req, res) => {
    try {
        const { status } = req.body; // 'accepted' or 'rejected'
        const currentUser = req.user;

        if (!['super_admin', 'owner', 'staff'].includes(currentUser.role)) {
            return res.status(403).json({ message: 'Access denied' });
        }
        if (!['accepted', 'rejected'].includes(status)) {
            return res.status(400).json({ message: 'Invalid status' });
        }

        const suggestion = await ProductSuggestion.findById(req.params.id);
        if (!suggestion) return res.status(404).json({ message: 'Suggestion not found' });

        if (currentUser.role !== 'super_admin' && suggestion.companyName !== currentUser.companyName) {
            return res.status(403).json({ message: 'Access denied' });
        }

        suggestion.status = status;
        await suggestion.save();

        // If accepted, auto-create the Product
        if (status === 'accepted') {
            const productCode = Math.random().toString(36).substring(2, 10).toUpperCase() + 
                                Math.random().toString(36).substring(2, 10).toUpperCase();

            const product = new Product({
                productCode,
                name: suggestion.name,
                price: suggestion.price,
                quantity: 0,
                category: suggestion.category,
                description: suggestion.description,
                companyName: suggestion.companyName,
                createdBy: currentUser._id,
                creatorRole: currentUser.role
            });

            await product.save();
            return res.status(200).json({ message: 'Suggestion accepted and product created', suggestion, product });
        }

        res.status(200).json({ message: `Suggestion ${status}`, suggestion });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- Category Management APIs ---

// 12. Create Category (Owner/Staff only)
app.post('/api/categories', auth, async (req, res) => {
    try {
        const { name } = req.body;
        const currentUser = req.user;

        // Only super_admin, owner, or staff can create categories
        if (!['super_admin', 'owner', 'staff'].includes(currentUser.role)) {
            return res.status(403).json({ message: 'Access denied' });
        }

        const category = new Category({
            name,
            companyName: currentUser.companyName,
            createdBy: currentUser._id
        });

        await category.save();
        res.status(201).json({ message: 'Category created successfully', category });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 13. List Categories (Role-based)
app.get('/api/categories', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        let query = {};

        if (currentUser.role === 'super_admin') {
            query = {};
        } else {
            query = { companyName: currentUser.companyName };
        }

        const categories = await Category.find(query);
        res.status(200).json(categories);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- Cart & Order Management APIs ---

// 14. Add to Cart (Staff and User)
app.post('/api/cart', auth, async (req, res) => {
    try {
        const { productId, quantity } = req.body;
        const currentUser = req.user;

        const product = await Product.findById(productId);
        if (!product) return res.status(404).json({ message: 'Product not found' });

        // Check stock availability
        if (product.quantity < (quantity || 1)) {
            return res.status(400).json({ message: `Only ${product.quantity} items left in stock` });
        }

        let cart = await Cart.findOne({ userId: currentUser._id });

        if (!cart) {
            cart = new Cart({
                userId: currentUser._id,
                companyName: currentUser.companyName,
                items: []
            });
        }

        // Check if product already in cart
        const itemIndex = cart.items.findIndex(p => p.productId.toString() === productId);
        if (itemIndex > -1) {
            const newTotal = cart.items[itemIndex].quantity + (quantity || 1);
            if (product.quantity < newTotal) {
                return res.status(400).json({ message: `Cannot add more. Total in cart would exceed stock (${product.quantity})` });
            }
            cart.items[itemIndex].quantity = newTotal;
        } else {
            cart.items.push({
                productId,
                name: product.name,
                price: product.price,
                quantity: quantity || 1
            });
        }

        await cart.save();
        res.status(200).json({ message: 'Item added to cart', cart });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 14a. Update Cart Item Quantity
app.patch('/api/cart/:productId', auth, async (req, res) => {
    try {
        const { quantity } = req.body;
        const productId = req.params.productId;
        const currentUser = req.user;

        const product = await Product.findById(productId);
        if (!product) return res.status(404).json({ message: 'Product not found' });

        if (product.quantity < quantity) {
            return res.status(400).json({ message: `Only ${product.quantity} items left in stock` });
        }

        const cart = await Cart.findOne({ userId: currentUser._id });
        if (!cart) return res.status(404).json({ message: 'Cart not found' });

        const itemIndex = cart.items.findIndex(p => p.productId.toString() === productId);
        if (itemIndex === -1) return res.status(404).json({ message: 'Item not in cart' });

        if (quantity <= 0) {
            cart.items.splice(itemIndex, 1);
        } else {
            cart.items[itemIndex].quantity = quantity;
        }

        await cart.save();
        res.status(200).json({ message: 'Cart updated', cart });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 15. Get Cart
app.get('/api/cart', auth, async (req, res) => {
    try {
        const cart = await Cart.findOne({ userId: req.user._id }).lean();
        if (!cart) return res.status(200).json({ items: [] });

        // Add current stock to each item for frontend validation
        const itemsWithStock = await Promise.all(cart.items.map(async (item) => {
            const product = await Product.findById(item.productId);
            return {
                ...item,
                stock: product ? product.quantity : 0
            };
        }));

        res.status(200).json({ ...cart, items: itemsWithStock });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 16. Create Order (Checkout)
app.post('/api/orders', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        const cart = await Cart.findOne({ userId: currentUser._id });

        if (!cart || cart.items.length === 0) {
            return res.status(400).json({ message: 'Cart is empty' });
        }

        // Verify stock for all items before creating order
        for (const item of cart.items) {
            const product = await Product.findById(item.productId);
            if (!product || product.quantity < item.quantity) {
                return res.status(400).json({ 
                    message: `Stock issue for ${item.name}. Available: ${product ? product.quantity : 0}, Required: ${item.quantity}` 
                });
            }
        }

        const totalAmount = cart.items.reduce((acc, item) => acc + (item.price * item.quantity), 0);

        const order = new Order({
            userId: currentUser._id,
            userRole: currentUser.role,
            companyName: currentUser.companyName,
            items: cart.items,
            totalAmount,
            status: 'pending' // Initial status
        });

        // Decrement stock for each item
        for (const item of cart.items) {
            await Product.findByIdAndUpdate(item.productId, {
                $inc: { quantity: -item.quantity }
            });
        }

        await order.save();
        
        // Clear the cart after order
        await Cart.deleteOne({ userId: currentUser._id });

        res.status(201).json({ message: 'Order created successfully', order });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 17. List Orders (Role-based)
app.get('/api/orders', auth, async (req, res) => {
    try {
        const currentUser = req.user;
        let query = {};

        if (currentUser.role === 'super_admin') {
            query = {};
        } else if (currentUser.role === 'owner' || currentUser.role === 'staff') {
            query = { companyName: currentUser.companyName };
        } else {
            // regular user only sees their own orders for the selected company
            query = { userId: currentUser._id, companyName: currentUser.companyName };
        }

        const orders = await Order.find(query).sort({ createdAt: -1 });
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 18. Update Order Status
app.put('/api/orders/:id/status', auth, async (req, res) => {
    try {
        const { status } = req.body;
        const order = await Order.findById(req.params.id);
        
        if (!order) return res.status(404).json({ message: 'Order not found' });

        // Authorization check
        const currentUser = req.user;
        const isStaffOrAdmin = currentUser.role === 'staff' || currentUser.role === 'super_admin';
        const isOwner = currentUser.role === 'owner' && currentUser.companyName === order.companyName;
        const isOrderUser = currentUser.role === 'user' && currentUser._id.toString() === order.userId.toString();

        if (status === 'paid' && (isOrderUser || isStaffOrAdmin || isOwner)) {
            // Anyone can mark as paid if they are related to the order
            order.status = status;
        } else if (status === 'completed' && isStaffOrAdmin && order.status === 'paid') {
            // ONLY staff or super_admin can mark as completed, and ONLY if it was paid
            order.status = status;
        } else if (isStaffOrAdmin || isOwner) {
            // General status updates for staff/owner
            order.status = status;
        } else {
            return res.status(403).json({ message: 'Access denied: Invalid status transition or insufficient permissions' });
        }

        await order.save();
        res.status(200).json({ message: 'Order status updated', order });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// 19. Generate PDF Invoice
app.get('/api/orders/:id/invoice', async (req, res) => {
    try {
        // Support token in header or query param for download convenience
        let token = req.headers.authorization;
        if (!token && req.query.token) {
            token = `Bearer ${req.query.token}`;
        }

        if (!token) return res.status(401).json({ message: 'Authentication required' });

        const jwt = require('jsonwebtoken');
        const decoded = jwt.verify(token.replace('Bearer ', ''), process.env.JWT_SECRET);
        
        const order = await Order.findById(req.params.id);
        if (!order) return res.status(404).json({ message: 'Order not found' });

        // Ensure user belongs to order or is staff/owner
        const user = await User.findById(decoded.userId);
        if (!user) return res.status(401).json({ message: 'Invalid user' });

        if (user.role !== 'super_admin' && 
            user.companyName !== order.companyName && 
            user._id.toString() !== order.userId.toString()) {
            return res.status(403).json({ message: 'Access denied' });
        }

        const PDFDocument = require('pdfkit');
        const doc = new PDFDocument({ margin: 50 });

        // HTTP headers for PDF download
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=invoice-${order.id}.pdf`);

        doc.pipe(res);

        // Header
        doc.fillColor('#444444')
           .fontSize(20)
           .text('INVOICE', 110, 57)
           .fontSize(10)
           .text(order.companyName, 200, 65, { align: 'right' })
           .text('Billing App System', 200, 80, { align: 'right' })
           .moveDown();

        // Order Info
        doc.fillColor('#000000')
           .fontSize(10)
           .text(`Order ID: ${order.id}`, 50, 150)
           .text(`Date: ${new Date(order.createdAt).toLocaleDateString()}`, 50, 165)
           .text(`Status: ${order.status.toUpperCase()}`, 50, 180)
           .moveDown();

        // Table Header
        const tableTop = 230;
        doc.font('Helvetica-Bold');
        doc.text('Item', 50, tableTop);
        doc.text('Quantity', 250, tableTop, { width: 90, align: 'right' });
        doc.text('Price', 340, tableTop, { width: 90, align: 'right' });
        doc.text('Total', 430, tableTop, { width: 90, align: 'right' });
        doc.moveTo(50, tableTop + 15).lineTo(520, tableTop + 15).stroke();

        // Table Rows
        let position = tableTop + 30;
        doc.font('Helvetica');
        order.items.forEach(item => {
            doc.text(item.name, 50, position);
            doc.text(item.quantity.toString(), 250, position, { width: 90, align: 'right' });
            doc.text(`$${item.price.toFixed(2)}`, 340, position, { width: 90, align: 'right' });
            doc.text(`$${(item.price * item.quantity).toFixed(2)}`, 430, position, { width: 90, align: 'right' });
            position += 20;
        });

        // Summary
        doc.moveTo(50, position + 10).lineTo(520, position + 10).stroke();
        doc.font('Helvetica-Bold');
        doc.fontSize(12)
           .text('GRAND TOTAL:', 340, position + 25, { width: 90, align: 'right' })
           .text(`$${order.totalAmount.toFixed(2)}`, 430, position + 25, { width: 90, align: 'right' });

        doc.end();
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- WebSocket Logic ---

io.use(async (socket, next) => {
    try {
        const token = socket.handshake.auth?.token || socket.handshake.query?.token;
        if (!token) return next(new Error('Authentication error'));

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await User.findById(decoded.userId);
        if (!user) return next(new Error('User not found'));

        socket.user = user;
        next();
    } catch (err) {
        next(new Error('Authentication error'));
    }
});

io.on('connection', (socket) => {
    console.log(`User connected: ${socket.user._id} (${socket.user.role})`);

    // Join a room unique to this user
    socket.join(socket.user._id.toString());

    socket.on('send_message', async (data) => {
        try {
            console.log(`\n--- NEW MESSAGE INCOMING ---`);
            console.log(`Payload received:`, data);
            
            const { receiverId, text } = data;
            const sender = socket.user;
            console.log(`Sender: ${sender._id} (Role: ${sender.role}, Company: ${sender.companyName})`);

            // Validate receiver exists and is in the same company
            const receiver = await User.findById(receiverId);
            if (!receiver) {
                console.log(`❌ BLOCK: Receiver ID ${receiverId} not found in database.`);
                return;
            }
            
            console.log(`Receiver: ${receiver._id} (Role: ${receiver.role}, Company: ${receiver.companyName})`);
            
            if (receiver.companyName !== sender.companyName) {
                console.log(`❌ BLOCK: Company mismatch! Sender: '${sender.companyName}', Receiver: '${receiver.companyName}'`);
                return;
            }

            // Role-based routing validation
            let allowed = false;
            if (sender.role === 'owner' || sender.role === 'super_admin') {
                // Owner can talk to anyone in company
                allowed = true;
                console.log(`✅ ALLOWED: Sender is owner/admin.`);
            } else if (receiver.role === 'owner' || receiver.role === 'super_admin') {
                // Staff/User can only talk to Owner
                allowed = true;
                console.log(`✅ ALLOWED: Receiver is owner/admin.`);
            }

            if (!allowed) {
                console.log(`❌ BLOCK: Role restriction. ${sender.role} cannot message ${receiver.role}`);
                return;
            }

            const message = new Message({
                sender: sender._id,
                receiver: receiver._id,
                text,
                companyName: sender.companyName
            });

            await message.save();

            // Emit to receiver's room
            console.log(`📤 Emitting 'receive_message' to room: ${receiverId}`);
            io.to(receiverId).emit('receive_message', message);
            
            // Confirm back to sender
            console.log(`📤 Emitting 'message_sent' confirmation to sender: ${sender._id}`);
            socket.emit('message_sent', message);

        } catch (error) {
            console.error('Chat Error:', error);
        }
    });

    socket.on('disconnect', () => {
        console.log(`User disconnected: ${socket.user._id}`);
    });
});

server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

