    // parqueaderos_api_backend/src/middleware/auth.js
    const jwt = require('jsonwebtoken');
    const User = require('../models/User'); // Asegúrate que el path y el nombre del modelo sean correctos
    require('dotenv').config();

    const authenticate = async (req, res, next) => {
        const authHeader = req.header('Authorization');

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ error: 'Acceso denegado. Token no proporcionado o en formato incorrecto.' });
        }

        const token = authHeader.replace('Bearer ', '');

        try {
            // Verificar el token usando la clave secreta de .env
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // 'decoded' contendrá el payload que usaste al firmar.
            // Si firmaste con { _id: user._id }, entonces decoded._id será el ID del usuario.
            const user = await User.findById(decoded._id).select('-password'); // Excluye la contraseña

            if (!user) {
                // Esto podría ocurrir si el usuario fue eliminado después de que el token fue emitido.
                return res.status(401).json({ error: 'Autenticación fallida. Usuario no encontrado.' });
            }

            req.user = user; // Adjuntar el objeto usuario (sin contraseña) a la solicitud
            next();
        } catch (error) {
            console.error('Error de autenticación de token:', error.message);
            if (error.name === 'JsonWebTokenError') {
                return res.status(401).json({ error: 'Token inválido.' });
            }
            if (error.name === 'TokenExpiredError') {
                return res.status(401).json({ error: 'Token expirado.' });
            }
            res.status(401).json({ error: 'Autenticación fallida. Por favor, inicie sesión de nuevo.' });
        }
    };

    module.exports = { authenticate };
    