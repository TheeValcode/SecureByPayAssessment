const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = process.env.PORT || 5000;
const JWT_SECRET = process.env.JWT_SECRET || 'securebypay_secret_key_2026';

app.use(cors());
app.use(express.json());

// In-memory data store for demonstration
// Seeded demo account for serverless testing (Password: Password123!)
const users = [
  {
    id: 'usr_demo_1',
    fullName: 'Jane Doe',
    email: 'jane@example.com',
    phoneNumber: '+2348012345678',
    password: '$2a$10$e74n6H.05Z4EaA6gJ4h8z.8l0nU2l4E.x.8n.1e.4l0nU2l4E.x.', // Hashed password
    createdAt: new Date().toISOString()
  }
];

// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ status: 'error', message: 'Access token missing' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ status: 'error', message: 'Invalid or expired token' });
    }
    req.user = user;
    next();
  });
};

// Sign-Up Endpoint
app.post('/api/v1/auth/signup', async (req, res) => {
  try {
    const { fullName, email, password, phoneNumber } = req.body;

    if (!fullName || !email || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'fullName, email, and password are required fields.'
      });
    }

    const existingUser = users.find(u => u.email.toLowerCase() === email.toLowerCase());
    if (existingUser) {
      return res.status(409).json({
        status: 'error',
        message: 'An account with this email address already exists.'
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = {
      id: `usr_${Date.now()}`,
      fullName,
      email: email.toLowerCase(),
      phoneNumber: phoneNumber || '',
      password: hashedPassword,
      createdAt: new Date().toISOString()
    };

    users.push(newUser);

    const token = jwt.sign(
      { id: newUser.id, email: newUser.email, fullName: newUser.fullName },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.status(201).json({
      status: 'success',
      message: 'Registration successful',
      data: {
        user: {
          id: newUser.id,
          fullName: newUser.fullName,
          email: newUser.email,
          phoneNumber: newUser.phoneNumber
        },
        token
      }
    });
  } catch (error) {
    return res.status(500).json({ status: 'error', message: 'Internal server error' });
  }
});

// Login Endpoint
app.post('/api/v1/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Email and password are required.'
      });
    }

    const user = users.find(u => u.email.toLowerCase() === email.toLowerCase());
    if (!user) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid email or password.'
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid email or password.'
      });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email, fullName: user.fullName },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.status(200).json({
      status: 'success',
      message: 'Login successful',
      data: {
        user: {
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber
        },
        token
      }
    });
  } catch (error) {
    return res.status(500).json({ status: 'error', message: 'Internal server error' });
  }
});

// Authenticated User Profile Endpoint
app.get('/api/v1/auth/me', authenticateToken, (req, res) => {
  const user = users.find(u => u.id === req.user.id);
  if (!user) {
    return res.status(404).json({ status: 'error', message: 'User not found' });
  }

  return res.status(200).json({
    status: 'success',
    data: {
      user: {
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber
      }
    }
  });
});

// Mock Dashboard / Interactive backend data endpoint
app.get('/api/v1/dashboard/summary', authenticateToken, (req, res) => {
  return res.status(200).json({
    status: 'success',
    data: {
      balance: '$12,450.80',
      transactions: [
        { id: 'tx_1', title: 'Payment received from Tech Corp', amount: '+$1,200.00', date: '2026-09-24' },
        { id: 'tx_2', title: 'Subscription renewal - Cloud Hosting', amount: '-$89.00', date: '2026-09-22' },
        { id: 'tx_3', title: 'Transfer to Bank Account', amount: '-$500.00', date: '2026-09-20' }
      ]
    }
  });
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Backend server running on http://localhost:${PORT}`);
  });
}

module.exports = app;
