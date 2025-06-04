    // parqueaderos_api_backend/src/models/Parking.js
    import { Schema, model } from 'mongoose';

    const parkingSchema = new Schema({
        name: { // Corresponde a 'nombre' en Flutter
            type: String,
            required: [true, 'El nombre del parqueadero es obligatorio.'],
            trim: true,
        },
        address: { // Corresponde a 'direccion' en Flutter
            type: String,
            required: [true, 'La dirección es obligatoria.'],
            trim: true,
        },
        location: { // Para consultas geoespaciales, compatible con GeoJSON
            type: {
                type: String,
                enum: ['Point'], // Solo tipo 'Point'
                required: true,
            },
            coordinates: { // Array de [longitud, latitud]
                type: [Number],
                required: true,
                validate: {
                    validator: function(coords) {
                        // Longitud entre -180 y 180, Latitud entre -90 y 90
                        return coords.length === 2 &&
                               coords[0] >= -180 && coords[0] <= 180 &&
                               coords[1] >= -90 && coords[1] <= 90;
                    },
                    message: 'Coordenadas inválidas. Deben ser [longitud, latitud].'
                }
            }
        },
        pricePerHour: { // Corresponde a 'tarifaPorHora'
            type: Number,
            required: false, // Puede ser opcional inicialmente
            min: 0
        },
        capacityTotal: { // Corresponde a 'capacidadTotal'
            type: Number,
            required: [true, 'La capacidad total es obligatoria.'],
            min: 0
        },
        availableSpots: { // Corresponde a 'disponibles'
            type: Number,
            required: true,
            min: 0,
            validate: { // Los disponibles no pueden exceder la capacidad total
                validator: function(value) {
                    return value <= this.capacityTotal;
                },
                message: 'Los puestos disponibles no pueden exceder la capacidad total.'
            }
        },
        schedule: { // Corresponde a 'horario'
            type: String,
            trim: true,
            required: false, // Opcional
        },
        owner: { // Quién registró el parqueadero
            type: Schema.Types.ObjectId,
            ref: 'User', // Referencia al modelo User
            required: true,
        },
        // Otros campos que puedas necesitar:
        // amenities: [String], // Ej: ['techado', 'vigilancia']
        // type: { type: String, enum: ['carro', 'moto', 'ambos'], default: 'carro' }
    }, {
        timestamps: true // Añade createdAt y updatedAt automáticamente
    });

    // Crear un índice geoespacial para búsquedas eficientes por ubicación
    parkingSchema.index({ location: '2dsphere' });

    // Middleware para asegurar que availableSpots no sea negativo y se actualice si capacityTotal cambia
    parkingSchema.pre('save', function(next) {
        if (this.availableSpots > this.capacityTotal) {
            this.availableSpots = this.capacityTotal;
        }
        if (this.availableSpots < 0) {
            this.availableSpots = 0;
        }
        next();
    });

    const Parking = model('Parking', parkingSchema);

    export default Parking;
    