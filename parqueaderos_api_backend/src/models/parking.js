import mongoose from 'mongoose';

const ParqueaderoSchema = new mongoose.Schema({
  nombre:      { type: String, required: true },
  plazas:      { type: Number, required: true },
  tarifa:      { type: Number, required: true },
  duenio:      { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  localizacion: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true } // [lon, lat]
  }
}, { timestamps: true });

// Índice geoespacial
ParqueaderoSchema.index({ localizacion: '2dsphere' });

export default mongoose.model('Parqueadero', ParqueaderoSchema);
