import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Checks and requests location permissions
  Future<bool> checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<bool> test() async {
    return true;
  }

  /// Gets current location
  Future<Position?> getCurrentCoordinates() async {
    if (!await checkLocationPermissions()) return null;

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  /// Converts coordinates to a readable address
  Future<String?> getAddress(Position position) async {
    await setLocaleIdentifier('pt_BR');
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;

      return "${p.street}, ${p.subLocality}";
    }

    return null;
  }

  Future<String?> getCurrentAddress() async {
    final position = await getCurrentCoordinates();

    if (position != null) {
      return await getAddress(position);
    }
    return null;
  }
}
