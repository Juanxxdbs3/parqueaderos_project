    // parqueaderos_api_backend/src/routes/parking_routes.js
    import { Router } from 'express';
    const router = Router();
    // Asegúrate que el nombre del archivo del controller sea el correcto
    import { createParking,getAllParkings,getNearbyParkings } from '../controllers/parkingController';
    import { authenticate } from '../middleware/auth'; // Asegúrate que el path sea correcto

    // Ruta protegida: Crear un nuevo parqueadero (solo usuarios autenticados)
    // POST /api/parking/
    router.post('/', authenticate, createParking);

    // Ruta pública: Obtener todos los parqueaderos (puede ser útil para un panel de admin)
    // GET /api/parking/all (cambié la ruta para diferenciarla)
    router.get('/all', getAllParkings);

    // NUEVA RUTA PÚBLICA: Obtener parqueaderos cercanos por coordenadas
    // GET /api/parking/cercanos?lat=xx.xxx&lon=yy.yyy&radio=5000
    router.get('/cercanos', getNearbyParkings);

    // Podrías añadir más rutas aquí:
    // GET /api/parking/:id (obtener un parqueadero por ID)
    // PUT /api/parking/:id (actualizar un parqueadero, protegido)
    // DELETE /api/parking/:id (eliminar un parqueadero, protegido)

    export default router;
    