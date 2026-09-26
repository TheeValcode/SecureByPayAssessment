# SecureByPay Assessment

Full-stack financial web application built with **Flutter Web** frontend and a **Node.js / Express** backend, featuring authentication flows (Sign-Up, Login) and adaptive responsive layouts for desktop, tablet, and mobile devices.

---

## 🚀 Features

- **Responsive Web UI**: Built with Flutter Web using modern typography (`GoogleFonts`), custom dark mode theme, glassmorphism card styling, and multi-breakpoint responsive layouts (`ResponsiveLayout`).
- **RESTful Authentication API**: Node.js & Express API providing secure endpoints for registration (`/api/v1/auth/signup`), authentication (`/api/v1/auth/login`), JWT token generation, and password hashing (`bcryptjs`).
- **Interactive Dashboard**: Protected user state and interactive balance summary.

---

## 💾 Data Storage & User Persistence

- **In-Memory User Store**: User accounts are dynamically created and stored in server memory (`const users = []`) with passwords securely encrypted via `bcryptjs`.
- **Dynamic Registration & Authentication**: Any user can sign up with arbitrary custom details (Name, Email, Phone Number, Password) and immediately log in with those registered credentials.
- **Session Lifetime**: User data remains available across Sign-Up and Login flows while the backend server process (`backend/index.js`) is active. Restarting the server resets the temporary in-memory store.

---

## 📁 Repository Structure

```
SecureByPayAssessment/
├── backend/                  # Node.js + Express API server
│   ├── index.js              # Auth endpoints & REST routes
│   └── package.json          # Node dependencies
├── frontend/                 # Flutter Web application
│   ├── lib/
│   │   ├── auth_provider.dart    # State management & API integration
│   │   ├── responsive_layout.dart # Breakpoint layout builder
│   │   └── main.dart             # UI screens & auth form components
│   └── pubspec.yaml          # Flutter dependencies
├── .gitignore                # Ignore rules for Node & Flutter builds
└── README.md                 # Project guide & instructions
```

---

## 🛠 Setup & Run Instructions

### Prerequisites

- **Node.js** (v18 or higher) & **npm**
- **Flutter SDK** (v3.19+ with Web support enabled)
- Chrome or modern web browser

---

### 1. Start the Backend API Server

Navigate to the `backend` directory, install dependencies, and start the Express server:

```bash
cd backend
npm install
npm start
```

> **Note**: The backend runs by default at `http://localhost:5000`.

---

### 2. Start the Frontend App (Flutter Web)

In a new terminal window, navigate to the `frontend` directory and run the Flutter Web application:

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

---

## 🧪 Running Tests & Verification

### Frontend Analysis & Tests
```bash
cd frontend
flutter analyze
flutter test
```

### Testing Backend Endpoints via Curl

**Sign-Up User**:
```bash
curl -X POST http://localhost:5000/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Jane Doe","email":"jane@example.com","password":"Password123!"}'
```

**Login User**:
```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"jane@example.com","password":"Password123!"}'
```
