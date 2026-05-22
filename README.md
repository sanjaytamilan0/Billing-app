# Billing App - Monorepo

This repository contains both the backend server and the mobile application for the Billing App.

## Project Structure

```text
.
├── server/          # Node.js Express API
└── mobile/          # Flutter Mobile Application
```

---

## 🚀 Server (Node.js/Express)

The backend is built with **Node.js, Express, MongoDB**, and **JWT Authentication**.

### Getting Started
1. Navigate to the server directory: `cd server`
2. Install dependencies: `npm install`
3. Set up environment variables in a `.env` file (see `.env.example`).
4. Start the server: `npm run dev`

### API Documentation
Base URL: `https://billing-app-k53w.onrender.com`

#### 1. Public APIs
- `GET /` - Root test
- `GET /api/public/roles` - List all unique roles
- `POST /api/register` - Register a new user

#### 2. Authentication
- `POST /api/login` - Login and get JWT token

#### 3. Protected APIs (Requires Bearer Token)
- `POST /api/user/role` - Update my role
- `GET /api/users` - List users (RBAC)
- `POST /api/staff` - Create staff (Owner/Super Admin)
- `POST /api/products` - Create product (16-char code)
- `GET /api/products/code/:code` - Scan product
- `POST /api/cart` - Add items to cart
- `POST /api/orders` - Checkout and create order
- `GET /api/chat/history/:otherUserId` - Get message history
- `GET /api/chat/participants` - List chat users (Owner only)
- `GET /api/chat/owner` - Find company owner (Staff/User only)


---

## 📱 Mobile App (Flutter)

The mobile application is built with **Flutter** for cross-platform support (iOS & Android).

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- Android Studio / Xcode (for emulators)

### Getting Started
1. Navigate to the mobile directory: `cd mobile`
2. Install dependencies: `flutter pub get`
3. Run the application: `flutter run`

### Key Features
- **Role-based UI**: Dynamic dashboards for different user levels.
- **Inventory Scanner**: Integrated QR/Barcode scanning for the 16-character product codes.
- **Live Billing**: Real-time cart management and order processing.
- **Staff Management**: Interface for managing company staff and permissions.
- **Real-Time Chat**: Direct communication between Owner, Staff, and Users.

---

## 💬 Real-Time Chat System

The chat system uses **Socket.io** for real-time communication and enforces role-based routing rules to maintain order and privacy within each company.

### How it Works:
1. **Authentication**: WebSockets use the same JWT token as the REST APIs. The token is passed in the `auth` handshake.
2. **Room Isolation**: Each user joins a private room named after their `userId`. Messages are routed to these specific rooms.
3. **Routing Rules**:
   - **Owners**: Can view a list of all Staff and Users in their company. They can initiate a chat with anyone.
   - **Staff & Users**: Can only chat with the **Owner** of their company. When they tap "Chat", they are directly connected to the owner.
   - **Company Isolation**: Users can only see and message people belonging to the same `companyName`.
4. **Data Persistence**: All messages are saved to MongoDB, allowing users to see their full conversation history upon re-connecting.

---


---

## 🛠 Tech Stack

| Component | Technology |
| :--- | :--- |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB (Mongoose) |
| **Auth** | JWT (JSON Web Tokens) |
| **Mobile** | Flutter (Dart) |
| **Deployment** | Render (Server) |

---

## ⚙️ Environment Variables (Server)
Create a `.env` file in the `server` directory:
```env
PORT=5000
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
```

---

## 🤝 Contributing
1. Clone the repo: `git clone <repo-url>`
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request.
