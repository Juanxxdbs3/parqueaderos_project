import mongoose from 'mongoose';

const UserSchema = new mongoose.Schema({
  email:    { type: String, required: true, unique: true },
  password: { type: String, required: true },
  telefono: { type: String },
  nombre:   { type: String },
  tipo:     { type: String, enum: ['conductor','duenoparqueadero'], required: true },
  estado:   { type: Boolean, default: true }
}, { timestamps: true });

// En lugar de exportar directamente:
export default mongoose.models.User
  ? mongoose.models.User
  : mongoose.model('User', UserSchema);
