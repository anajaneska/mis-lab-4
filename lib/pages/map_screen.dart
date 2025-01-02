import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;


import '../model/exam.dart';

class MapScreen extends StatefulWidget {
  final List<Exam> exams;

  MapScreen({required this.exams});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> routePoints = [];
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permission denied forever");
      return;
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("User location: ${position.latitude}, ${position.longitude}");
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }



  Future<void> fetchRoute(LatLng start, LatLng end) async {
    const String apiKey = '5b3ce3597851110001cf62485946fea63af440abad3a5c075d1e2b44'; // Replace with your API key
    final url =
        'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=$apiKey&start=${start
        .longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List coordinates = data['features'][0]['geometry']['coordinates'];

      setState(() {
        routePoints = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      print("Failed to fetch route: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Locations and Route"),
      ),
      body: userLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: userLocation ?? LatLng(41.9981, 21.4254), // Default center (Skopje)
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [...widget.exams.map(
                  (exam) => Marker(
                      point: LatLng(exam.latitude, exam.longitude),
                      child: Builder(
                          builder: (ctx) => GestureDetector(
                            onTap: () async {
                              if (userLocation != null) {
                                await fetchRoute(userLocation!,
                                    LatLng(exam.latitude, exam.longitude));
                              }
                            },
                            child: Icon(
                              Icons.location_on,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                      )
                  )
            ),
              if (userLocation != null)
                Marker(
                  point: userLocation!,
                  child: Builder(
                      builder: (ctx) => Icon(
                        Icons.person_pin_circle,
                        size: 30,
                        color: Colors.blue,
                      )
                  ),
                ),

            ],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                ),
              ],
            ),
        ],
      ),
    );
  }
}