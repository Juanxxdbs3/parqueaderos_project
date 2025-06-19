import { createParking, findNearby } from '../services/parking_service.js';

export async function createParkingController(req, res, next) {
  try {
    const park = await createParking({ ...req.body, duenio: req.user._id });
    res.status(201).json(park);
  } catch (err) {
    next(err);
  }
}

export async function getNearbyController(req, res, next) {
  try {
    const { lat, lon, radio } = req.query;
    const parks = await findNearby(parseFloat(lat), parseFloat(lon), parseInt(radio));
    res.json(parks);
  } catch (err) {
    next(err);
  }
}
