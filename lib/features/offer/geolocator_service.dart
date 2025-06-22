import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

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

  Future<List<String>> getAddressSuggestions(String input) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=$input, São Paulo, Brazil'
      '&format=json'
      '&addressdetails=1'
      '&limit=5',
    ); // Only SP state

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'myapp/1.0', // Required by Nominatim's policy
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      final uniqueAddresses = <String>{};
      final List<String> filteredSuggestions = [];

      for (final item in data) {
        final address = item['address'];
        final street = address['road'] ?? '';
        final district = address['neighbourhood'] ?? '';
        final city = address['city'] ?? '';
        final fullAddress = [
          street,
          district,
          city,
        ].where((part) => part.isNotEmpty).join(', ');
        // Removes "duplicated" address (by values not shown)
        if (!uniqueAddresses.contains(fullAddress)) {
          uniqueAddresses.add(fullAddress);
          filteredSuggestions.add(fullAddress);
        }
      }

      return filteredSuggestions;
    } else {
      return [];
    }
  }

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=$address'
      '&format=json'
      '&limit=1',
    );

    final response = await http.get(uri, headers: {'User-Agent': 'myapp/1.0'});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final firstResult = data[0];
        final lat = double.tryParse(firstResult['lat']);
        final lon = double.tryParse(firstResult['lon']);
        if (lat != null && lon != null) {
          return LatLng(lat, lon);
        }
      }
    }
    return null;
  }

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
  Future<String?> getAddressFromCoordinates(double lat, lng) async {
    await setLocaleIdentifier('pt_BR');
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;

      return "${p.street}, ${p.subLocality}, ${p.subAdministrativeArea}";
    }

    return null;
  }

  Future<String?> getCurrentAddress() async {
    final position = await getCurrentCoordinates();

    if (position != null) {
      return await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    }
    return null;
  }
}
