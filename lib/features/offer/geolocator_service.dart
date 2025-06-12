import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  /// Checks and requests location permissions
  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Gets current location
  Future<Position?> getCurrentLocation() async {
    if (!await _checkLocationPermissions()) return null;

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  /// Shows a map for location selection and returns the selected address
  Future<String?> selectLocationFromMap(BuildContext context) async {
    if (!await _checkLocationPermissions()) return null;

    // Get current position to center the map
    Position? currentPosition = await getCurrentLocation();
    if (currentPosition == null) return null;

    LatLng? selectedPosition;

    // Show the map dialog
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select your location'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentPosition.latitude,
                    currentPosition.longitude,
                  ),
                  zoom: 14,
                ),
                onTap: (LatLng position) {
                  selectedPosition = position;
                  Navigator.pop(context);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );

    if (selectedPosition == null) return null;

    // Convert selected position to address
    return await getAddressFromCoordinates(
      selectedPosition!.latitude,
      selectedPosition!.longitude,
    );
  }

  /// Converts coordinates to a readable address
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return "${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}"
            .replaceAll(RegExp(r', , '), ', ')
            .replaceAll(RegExp(r', $'), '');
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
