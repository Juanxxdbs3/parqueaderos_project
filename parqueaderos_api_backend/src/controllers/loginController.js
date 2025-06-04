    // parqueaderos_api_backend/src/controllers/loginController.js
    const User = require('../models/User'); // Asegúrate que el path y el nombre del modelo sean correctos
    const bcrypt = require('bcryptjs');
    const jwt = require('jsonwebtoken');
    require('dotenv').config(); // Para acceder a process.env.JWT_SECRET

    // Inicio de sesión de usuario
    const login = async (req, res) => {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ error: 'Email y contraseña son requeridos.' });
        }

        try {
            // Verificar si el usuario existe
            const user = await User.findOne({ email });
            if (!user) {
                return res.status(400).json({ error: 'Credenciales incorrectas.' }); // Mensaje genérico
            }

            // Verificar la contraseña
            const isMatch = await bcrypt.compare(password, user.password);
            if (!isMatch) {
                return res.status(400).json({ error: 'Credenciales incorrectas.' }); // Mensaje genérico
            }

            // Generar JWT
            // Firmar con _id para que coincida con lo que espera el middleware de autenticación
            const payload = {
                _id: user._id,
                name: user.name, // Puedes añadir más info si la necesitas en el frontend sin otra consulta
                // rol: user.role // si tienes roles
            };

            const token = jwt.sign(
                payload,
                process.env.JWT_SECRET, // Usar la clave secreta desde .env
                { expiresIn: '1h' } // o '7d', '30d', etc.
            );

            // Enviar el token y datos básicos del usuario al cliente
            res.json({
                token,
                user: {
                    _id: user._id,
                    name: user.name,
                    email: user.email
                }
            });
        } catch (error) {
            console.error('Error en login:', error.message);
            res.status(500).json({ error: 'Hubo un error al iniciar sesión, por favor intente de nuevo más tarde.' });
        }
    };

    module.exports = { login };
    