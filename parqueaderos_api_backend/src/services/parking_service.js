import Parqueadero from '../models/parking.js';

export async function createParking(data) {
  const park = new Parqueadero(data);
  await park.save();
  return park;
}

export async function findNearby(lat, lon, radio) {
  return await Parqueadero.find({
    localizacion: {
      $near: {
        $geometry: { type: 'Point', coordinates: [lon, lat] },
        $maxDistance: radio
      }
    }
  });
}
