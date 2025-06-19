import User from '../models/User.js';
import jwt from 'jsonwebtoken';

export async function registerUser(data) {
  const user = new User(data);
  await user.save();
  return user;
}

export async function loginUser({ email, password }) {
  const user = await User.findOne({ email });
  if (!user) throw new Error('Usuario no encontrado');
  // TODO: comparar contraseñas con bcrypt
  const token = jwt.sign({ _id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
  return { user, token };
}
