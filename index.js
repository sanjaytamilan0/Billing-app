require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const User = require('./models/User');
const Note = require('./models/Note');
const Product = require('./models/Product');
const Category = require('./models/Category');
const Cart = require('./models/Cart');
const Order = require('./models/Order');
const auth = require('./middleware/auth');

const path = require('path');

const app = express();
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

// --- Protected APIs (Auth Required) ---

// 4. Update Current User Role
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
            // super_admin sees everyone
            query = {};
        } else if (currentUser.role === 'owner') {
            // owner sees only their company's users
            query = { companyName: currentUser.companyName };
        } else {
            // Other roles are not allowed to see the list
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
        const { name, price, category, description } = req.body;
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
            cart.items[itemIndex].quantity += quantity || 1;
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

// 15. Get Cart
app.get('/api/cart', auth, async (req, res) => {
    try {
        const cart = await Cart.findOne({ userId: req.user._id });
        res.status(200).json(cart || { items: [] });
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

        const totalAmount = cart.items.reduce((acc, item) => acc + (item.price * item.quantity), 0);

        const order = new Order({
            userId: currentUser._id,
            userRole: currentUser.role,
            companyName: currentUser.companyName,
            items: cart.items,
            totalAmount,
            status: 'completed' // For basic testing, we mark it completed immediately
        });

        await order.save();
        
        // Clear the cart after order
        await Cart.findOneAndDelete({ userId: currentUser._id });

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
        } else if (currentUser.role === 'owner') {
            query = { companyName: currentUser.companyName };
        } else {
            // staff and user only see their own orders
            query = { userId: currentUser._id };
        }

        const orders = await Order.find(query).sort({ createdAt: -1 });
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
