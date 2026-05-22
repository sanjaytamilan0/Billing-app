# Full-Stack Mobile App & Node.js Server

This project is a complete full-stack application featuring a cross-platform mobile app built with Flutter and a powerful backend server powered by Node.js, Express, and MongoDB. The system supports real-time communication via Socket.IO, role-based access, inventory management, cart operations, order processing, and dynamic PDF invoice generation.

## 🌟 Key Features

* **Authentication & Authorization**: Secure JWT-based login/registration with Role-Based Access Control (RBAC).
* **Product & Inventory Management**: CRUD operations for products and categories.
* **Shopping Cart & Checkout**: Robust cart state management leading to order placement.
* **Order Processing**: Track orders, update statuses, and automatically generate and serve PDF invoices.
* **Real-time Chat**: Integrated Socket.IO for seamless messaging between users.
* **Staff Management**: Tools for handling internal staff roles and notes.

## 🛠 Tech Stack

### Mobile App (Flutter)
* **Framework**: Flutter (Dart)
* **State Management**: Riverpod & Freezed (immutable state)
* **Networking**: Dio (HTTP client) & Socket.io-client (Real-time events)
* **Routing**: GetX
* **UI/UX**: Skeletonizer (loading skeletons), Google Fonts

### Server (Node.js)
* **Framework**: Express.js
* **Database**: MongoDB (Mongoose ORM)
* **Real-time**: Socket.IO
* **Security**: JSON Web Tokens (JWT), CORS
* **Utilities**: PDFKit (for generating PDF invoices dynamically)

---

## 📂 Project Structure

```text
node_projects/
├── mobile/                 # Flutter Application
│   ├── lib/
│   │   ├── features/       # Feature-driven architecture
│   │   │   ├── auth/       # Login/Registration logic
│   │   │   ├── cart/       # Cart screen & state management
│   │   │   ├── chat/       # Real-time chat integration
│   │   │   ├── home/       # Main dashboard/home view
│   │   │   ├── orders/     # Order history and checkout
│   │   │   ├── products/   # Product listings and details
│   │   │   └── staff/      # Staff/Employee management
│   │   └── main.dart       # App entry point
│   └── pubspec.yaml        # Flutter dependencies
│
└── server/                 # Node.js Express Backend
    ├── index.js            # Main server entry & route definitions
    ├── models/             # Mongoose Schemas (User, Product, Cart, Order, Message, Note, Category)
    ├── middleware/         # Custom middlewares (e.g., Auth verification)
    ├── public/             # Static files directory
    ├── .env.example        # Environment variables template
    └── package.json        # Node dependencies
```

---

## 🚀 Getting Started

### 1. Server Setup

Navigate to the `server` directory and install the dependencies:
```bash
cd server
npm install
```

Set up your environment variables:
1. Copy the example env file: `cp .env.example .env`
2. Open `.env` and fill in your MongoDB connection string and JWT secret:
   ```env
   MONGO_URL=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret
   PORT=10000
   ```

Run the server:
* **Development mode** (uses nodemon): `npm run dev`
* **Production mode**: `npm start`

### 2. Mobile App Setup

Ensure you have Flutter installed. Then navigate to the `mobile` directory:
```bash
cd mobile
flutter pub get
```

**(Optional)** Run code generation if you make changes to Freezed models or Riverpod providers:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Run the app on an emulator or connected device:
```bash
flutter run
```

---

## 🔌 API Endpoints Summary

The server exposes a variety of RESTful endpoints:

**Public Routes:**
* `GET /ping`, `GET /hello` - Health checks
* `GET /api/public/roles`, `GET /api/public/companies` - Public data retrieval

**Authentication (Public):**
* `POST /api/register` - Create a new user
* `POST /api/login` - Authenticate and receive a JWT

**Protected Routes (Requires JWT Header):**
* **Users & Staff**: `GET /api/me`, `GET /api/users`, `POST /api/staff`, `PUT /api/staff/:id`, `DELETE /api/staff/:id`
* **Chat**: `GET /api/chat/history/:otherUserId`, `GET /api/chat/participants`
* **Products & Categories**: `GET /api/products`, `POST /api/products`, `PATCH /api/products/:id/quantity`, `GET /api/categories`, `POST /api/categories`
* **Cart**: `GET /api/cart`, `POST /api/cart`, `PATCH /api/cart/:productId`
* **Orders**: `GET /api/orders`, `POST /api/orders`, `PUT /api/orders/:id/status`, `GET /api/orders/:id/invoice` (Generates a dynamic PDF)

## 🔄 User Workflows

The application supports distinct workflows depending on the user's role (e.g., User, Staff, Owner, Super Admin) and their interaction with the system:

### 1. Authentication & Onboarding
* **Registration:** Users sign up using their phone number, password, role, and company name.
* **Login:** Upon login, a JWT is issued to the device and securely stored. This token is attached to all subsequent protected API requests.

### 2. Product Discovery & Shopping
* **Browsing:** Users can view categories and explore available products.
* **Cart Management:** Users can add products to their cart. The app enforces inventory checks (stock limits), meaning users cannot add more items than what is currently available. 

### 3. Order Processing & Invoicing
* **Checkout:** Once the cart is finalized, users can place an order.
* **Order Tracking:** Users can track the real-time status of their orders.
* **Invoicing:** When an order is completed, the system generates a dynamic PDF invoice that users can download.

### 4. Real-time Communication
* **Chat:** The integrated Socket.IO functionality allows users to communicate in real-time. **Owners** and **Super Admins** have the ability to chat with anyone in the company, while standard **Users** and **Staff** can only direct their messages to the Owner.
* **Chat History:** Previous messages are persisted in MongoDB and fetched upon entering a chat room.

### 5. Owner, Admin & Staff Operations
* **Company Ownership:** The **Owner** acts as the primary administrator for their company. They can manage all inventory, oversee all orders, and respond to all customer chats.
* **Inventory Management:** Owners and Staff can add or update products, adjust stock quantities, and manage categories.
* **Order Management:** Owners and Staff can update the status of orders as they are processed.
* **Staff Access:** Owners and Super Admins can create and manage other staff members, assigning them specific permissions and roles within the company.

## 🚀 Future Enhancements / Roadmap (Flow-wise)

Here are the potential feature upgrades planned for future releases, organized by user workflow:

### 1. Authentication & Onboarding
* **Social Login & SSO:** Allow users to register and log in quickly using Google, Apple, or Microsoft accounts.
* **Two-Factor Authentication (2FA):** Enhance security for Owner and Super Admin accounts.

### 2. Product Discovery & Shopping
* **Advanced Search & Filtering:** Full-text search for products combined with multi-faceted filtering (by price range, availability, and specific attributes).
* **AI-driven Recommendations:** Suggest products based on a user's previous order history and company profile.

### 3. Order Processing & Invoicing
* **Payment Gateway Integration:** Built-in support for processing online payments (e.g., Stripe, PayPal, Razorpay) directly during checkout.
* **Order Push Notifications:** Integration with Firebase Cloud Messaging (FCM) to alert users about real-time order status changes.

### 4. Real-time Communication
* **Media Sharing in Chat:** Allow users and staff to share images, PDFs, or invoice documents directly in the chat.
* **Read Receipts & Typing Indicators:** Provide better visual feedback during live chat sessions.

### 5. Owner, Admin & Staff Operations
* **Analytics & Dashboard Reporting:** Visual charts and graphs giving Owners insights into sales trends, top-selling products, and revenue over time.
* **Automated Low-Stock Alerts:** Push notifications or emails sent to staff and owners when a product's inventory drops below a specific threshold.

### App-wide Improvements
* **Multi-language Support (Localization):** Adding support for multiple languages and regional formats.
* **Dark Mode:** A polished system-wide dark theme for the Flutter application.

## 🤝 Contribution Guidelines
Follow the feature-based folder structure inside `lib/features/` when adding new functionalities to the app. Make sure to run `build_runner` if you modify or add any Riverpod or Freezed annotations.
