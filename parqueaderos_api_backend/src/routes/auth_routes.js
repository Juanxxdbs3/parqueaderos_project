const express = require('express');
const router = express.Router();
const { register } = require('../controllers/authController');
const { login } = require('../controllers/loginController');  // Importa loginController

// Ruta de registro
router.post('/register', register);

// Ruta de inicio de sesión
router.post('/login', login);

module.exports = router;