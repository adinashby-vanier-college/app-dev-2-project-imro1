import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/src/layer/marker_layer.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  LatLng _currentLocation = LatLng(40.712776, -74.005974);
  LatLng _destination = LatLng(48.8566, 2.3522);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.teal,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _currentLocation,
          zoom: 10.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _currentLocation,
                builder: (ctx) =>
                    TweenAnimationBuilder(
                      tween: Tween<LatLng>(
                        begin: _currentLocation,
                        end: _destination,
                      ),
                      duration: const Duration(seconds: 10),
                      builder: (BuildContext context, LatLng value, Widget? child) {
                        return SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
