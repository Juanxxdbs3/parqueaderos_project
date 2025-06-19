import User from '../models/user.js';

export async function getUserById(id) {
  return await User.findById(id).select('-password');
}
