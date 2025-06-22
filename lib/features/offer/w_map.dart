import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelectableMap extends StatefulWidget {
  final LatLng center;
  final void Function(LatLng point) onTap;

  const SelectableMap({super.key, required this.center, required this.onTap});

  @override
  State<SelectableMap> createState() => _SelectableMapState();
}

class _SelectableMapState extends State<SelectableMap> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant SelectableMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.center != oldWidget.center) {
      // move map to new center
      _mapController.move(widget.center, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.center,
        initialZoom: 17.0,
        onTap: (tapPosition, point) => widget.onTap(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.center,
              width: 40,
              height: 40,
              child: const Icon(Icons.hail, color: Colors.red, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}
