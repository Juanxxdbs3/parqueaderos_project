import { registerUser, loginUser } from '../services/auth_service.js';

export async function registerController(req, res, next) {
  try {
    const user = await registerUser(req.body);
    res.status(201).json(user);
  } catch (err) {
    next(err);
  }
}

export async function loginController(req, res, next) {
  try {
    const { user, token } = await loginUser(req.body);
    res.json({ user, token });
  } catch (err) {
    next(err);
  }
}
