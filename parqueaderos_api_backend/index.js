// Importación de dependencias
import express, { json } from 'express';
import { connect } from 'mongoose';
import { config } from 'dotenv';
import cors from 'cors';

// Cargar variables de entorno desde el archivo .env
config();

// Inicializar la aplicación Express
const app = express();

// Middleware para analizar las solicitudes con formato JSON
app.use(json());

// Habilitar CORS (si es necesario para peticiones desde el frontend)
app.use(cors());

// Conexión a MongoDB (usando la URI desde .env)
connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
    .then(() => {
        console.log('🟢 MongoDB conectado correctamente');
    })
    .catch((error) => {
        console.error('🔴 Error al conectar a MongoDB:', error);
    });

// Rutas
import authRoutes from './routes/auth_routes';
app.use('/api/auth', authRoutes);  // Ruta de autenticación
import parkingRoutes from './routes/parking_routes';
app.use('/api/parking', parkingRoutes);
// Puerto en el que se ejecuta el servidor
const PORT = process.env.PORT || 5003; // Usar puerto del entorno si está disponible, o 5003 por defecto

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`🚀 Servidor ejecutándose en el puerto ${PORT}`);
});
