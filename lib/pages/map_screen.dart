import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';


import '../model/exam.dart';

class MapScreen extends StatelessWidget {
  final List<Exam> exams;

  MapScreen({required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Locations"),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: exams.isNotEmpty
              ? LatLng(exams.first.latitude, exams.first.longitude)
              : LatLng(41.9981, 21.4254), // Default center (Skopje)
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OpenStreetMap Tile Server
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: exams.map((exam) {
              return Marker(
                point: LatLng(exam.latitude, exam.longitude), // LatLng for exam location
                width: 80.0,
                height: 80.0,
                child: GestureDetector( // Use child instead of builder
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(exam.name),
                        content: Text(
                          'Location: ${exam.location}\nDate: ${exam.date}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}