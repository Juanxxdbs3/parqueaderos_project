    // parqueaderos_api_backend/src/controllers/parkingController.js
    import Parking, { find } from '../models/Parking'; // Asegúrate que el path y el nombre del modelo sean correctos

    // Crear un nuevo parqueadero
    const createParking = async (req, res) => {
        try {
            // Los datos vienen del body de la solicitud
            // Flutter enviará: name, address, location (con type: 'Point', coordinates: [long, lat]),
            // pricePerHour, capacityTotal, availableSpots, schedule.
            const { name, address, location, pricePerHour, capacityTotal, availableSpots, schedule } = req.body;

            // Validaciones básicas (mongoose también valida según el esquema)
            if (!name || !address || !location || !location.coordinates || capacityTotal === undefined || availableSpots === undefined) {
                return res.status(400).json({ error: 'Faltan campos obligatorios: nombre, dirección, ubicación, capacidad total, puestos disponibles.' });
            }
            if (location.type !== 'Point' || !Array.isArray(location.coordinates) || location.coordinates.length !== 2) {
                return res.status(400).json({ error: 'Formato de ubicación inválido. Debe ser GeoJSON Point con [longitud, latitud].' });
            }


            const newParking = new Parking({
                name,
                address,
                location, // location: { type: "Point", coordinates: [longitude, latitude] }
                pricePerHour,
                capacityTotal,
                availableSpots,
                schedule,
                owner: req.user._id // Se asume que ya pasó por el middleware de autenticación y req.user está disponible
            });

            await newParking.save();
            res.status(201).json({ message: 'Parqueadero creado exitosamente.', parking: newParking });
        } catch (error) {
            console.error('Error al crear parqueadero:', error.message, error.stack);
            if (error.name === 'ValidationError') {
                return res.status(400).json({ error: 'Error de validación', details: error.errors });
            }
            res.status(500).json({ error: 'Error interno del servidor al crear el parqueadero.' });
        }
    };

    // Obtener todos los parqueaderos (esta ruta puede seguir existiendo si es útil para alguna vista de admin, por ejemplo)
    const getAllParkings = async (req, res) => {
        try {
            const parkings = await find().populate('owner', 'name email'); // 'owner' es el campo, 'name email' los campos a popular del User
            res.status(200).json(parkings);
        } catch (error) {
            console.error('Error al obtener todos los parqueaderos:', error.message);
            res.status(500).json({ error: 'Error interno del servidor al obtener parqueaderos.' });
        }
    };

    // NUEVA FUNCIÓN: Obtener parqueaderos cercanos
    const getNearbyParkings = async (req, res) => {
        const { lat, lon, radio } = req.query; // lat, lon, radio (en metros)

        if (!lat || !lon) {
            return res.status(400).json({ error: 'Latitud (lat) y longitud (lon) son requeridas como parámetros query.' });
        }

        const latitude = parseFloat(lat);
        const longitude = parseFloat(lon);
        const maxDistance = parseInt(radio) || 5000; // Radio en metros, 5km por defecto

        if (isNaN(latitude) || isNaN(longitude)) {
            return res.status(400).json({ error: 'Latitud y longitud deben ser números válidos.' });
        }

        try {
            const parkings = await find({
                location: {
                    $near: {
                        $geometry: {
                            type: 'Point',
                            coordinates: [longitude, latitude] // IMPORTANTE: MongoDB espera [longitud, latitud]
                        },
                        $maxDistance: maxDistance // Distancia en metros
                    }
                }
            }).populate('owner', 'name email'); // Opcional: popular datos del dueño

            // Mapear para que coincida con ParqueaderoModel de Flutter si es necesario,
            // o asegurar que el modelo de Flutter pueda parsear esto directamente.
            // El modelo Parking.js ya está bastante alineado.
            // Solo asegúrate que los nombres de campos coincidan o se mapeen en Flutter.
            // _id (Mongo) -> id (Flutter)
            // name (Mongo) -> nombre (Flutter)
            // address (Mongo) -> direccion (Flutter)
            // location (Mongo GeoJSON) -> ubicacion (Flutter LatLng)
            // availableSpots (Mongo) -> disponibles (Flutter)
            // capacityTotal (Mongo) -> capacidadTotal (Flutter)
            // pricePerHour (Mongo) -> tarifaPorHora (Flutter)
            // schedule (Mongo) -> horario (Flutter)

            res.status(200).json(parkings);
        } catch (error) {
            console.error('Error al obtener parqueaderos cercanos:', error.message);
            res.status(500).json({ error: 'Error interno del servidor al buscar parqueaderos cercanos.' });
        }
    };


    export default {
        createParking,
        getAllParkings,
        getNearbyParkings // Exportar la nueva función
    };
    