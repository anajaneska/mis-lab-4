
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

class Exam {
  final String name;
  final DateTime date;
  final String location;
  final String id;
  final double latitude;
  final double longitude;
  //final GeoPoint geoPoint;

  //ExamModel({this.id,this.name,this.eventDate}):super(id);
  Exam({required this.name, required this.date, required this.location, required this.id,required this.latitude, required this.longitude,});


  factory Exam.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    final geoPoint = data['Geopoint'] as GeoPoint;
    return Exam(
      date: data['DateTime'].toDate(),
      name: data['Name'],
      location: data['Location'],
      id: snapshot.id,
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }
  Map<String, Object?> toFirestore() {
    return {
      "Date": Timestamp.fromDate(date),
      "Name": name,
      "Location": location,
      "Geopoint": GeoPoint(latitude,longitude)
    };
  }

}