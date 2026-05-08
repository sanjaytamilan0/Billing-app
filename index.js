require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const User = require('./models/User');
const Note = require('./models/Note');
const auth = require('./middleware/auth');

const app = express();
const PORT = process.env.PORT || 10000;

// Middleware
app.use(cors());
app.use(express.json());

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

// 6. Create Note API
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

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
