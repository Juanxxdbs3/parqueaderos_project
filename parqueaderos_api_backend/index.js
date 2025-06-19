import express from 'express';
import cors from './src/config/cors.js';
import dotenv from './src/config/dotenv.js';
import { connectDB } from './src/config/db.js';
import authRoutes from './src/routes/auth_routes.js';
import userRoutes from './src/routes/user_routes.js';
import parkingRoutes from './src/routes/parking_routes.js';
import errorMiddleware from './src/middleware/error.js';

// Carga variables de entorno
dotenv.config();

const app = express();
app.use(express.json());
app.use(cors);

// Conexión a MongoDB
await connectDB();

// Definición de rutas
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/parking', parkingRoutes);

// Middleware global de errores
app.use(errorMiddleware);

const PORT = process.env.PORT || 5003;
app.listen(PORT, () => console.log(`🚀 Servidor ejecutándose en puerto ${PORT}`));
