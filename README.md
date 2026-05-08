# Billing App API Documentation

This backend is built with Node.js, Express, MongoDB, and JWT Authentication.

## Base URL
`https://billing-app-k53w.onrender.com`

---

## 1. Public APIs (No Authentication Required)

### 1.1 Root Test
- **URL**: `/`
- **Method**: `GET`
- **Description**: Verify the server is running.
- **Response**:
```json
{ "message": "Note API is working!" }
```

### 1.2 List All Unique Roles
- **URL**: `/api/public/roles`
- **Method**: `GET`
- **Description**: Get a list of all unique roles currently existing in the system.
- **Response**:
```json
["admin", "user", "manager"]
```

### 1.3 Register User
- **URL**: `/api/register`
- **Method**: `POST`
- **Request Body**:
```json
{
    "phone": "9876543210",
    "password": "mypassword",
    "role": "admin",
    "companyName": "Tech Solutions",
    "permissions": ["read", "write"] 
}
```
*Note: `permissions` is optional.*

---

## 2. Authentication

### 2.1 Login
- **URL**: `/api/login`
- **Method**: `POST`
- **Request Body**:
```json
{
    "phone": "9876543210",
    "password": "mypassword",
    "role": "admin"
}
```
- **Response**:
```json
{
    "token": "eyJhbG...",
    "userId": "663b...",
    "role": "admin",
    "permissions": ["read", "write"]
}
```

---

## 3. Protected APIs (Requires `Authorization: Bearer <token>`)

### 3.1 Update My Role
- **URL**: `/api/user/role`
- **Method**: `POST`
- **Request Body**:
```json
{
    "role": "super-admin"
}
```

### 3.2 Create Note
- **URL**: `/api/notes`
- **Method**: `POST`
- **Request Body**:
```json
{
    "title": "Meeting Notes",
    "content": "Discussed the new billing project."
}
```

### 3.3 Get My Notes
- **URL**: `/api/notes`
- **Method**: `GET`
- **Response**:
```json
[
    {
        "_id": "663b...",
        "title": "Meeting Notes",
        "content": "Discussed the new billing project.",
        "userId": "663a...",
        "createdAt": "2026-05-08T..."
    }
]
```
