import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'model/exam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CalendarApp());
}

class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  late DateTime _firstDay;
  late DateTime _lastDay;
  DateTime? _selectedDay;
  late Map<DateTime, List<Exam>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final snap = await FirebaseFirestore.instance
        .collection('Exam')
        .withConverter(
        fromFirestore: Exam.fromFirestore,
        toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              eventLoader: _getEventsForTheDay,
              focusedDay: _focusedDay,
              firstDay:DateTime.utc(2010, 10, 16),
              lastDay:DateTime.utc(2030, 3, 14),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            )
          ],
        )
      )
    );
  }
}

/*
class ExamListScreen extends StatefulWidget {
  @override
  _ExamListScreenState createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  @override
  void initState() {
    super.initState();
  }
  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    // Extract the necessary fields from the document
    //Timestamp timestamp = doc['DateTime']['Date'];
    //DateTime examDate = doc['DateTime']['Date'].toString() as DateTime;
    //String time = doc['DateTime']['Time'].toString();
   // String location = doc['Location'].toString();
    var dateTime = (doc['DateTime'] as Timestamp).toDate();
    var date = DateFormat('yyyy-MM-dd').format(dateTime);
    var time = DateFormat('HH:mm').format(dateTime);

    return ListTile(
      title:  Text(dateTime.toString()),
      subtitle: Text("Date: $date"),
      trailing: Text("Time: $time"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam List"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Exam').snapshots(),
        builder: (context,snapshot) {
          if(!snapshot.hasData) return const Text('loading');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
            _buildListItem(context, snapshot.data!.docs[index])
          );
        }

      ),
    );
  }
}*/
