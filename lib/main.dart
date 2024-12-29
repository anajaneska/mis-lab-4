import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_schedule/pages/add_exam.dart';
import 'package:exam_schedule/pages/map_screen.dart';
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
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};
    
    final snap = await FirebaseFirestore.instance
        .collection('Exam')
        .where('DateTime', isGreaterThanOrEqualTo: firstDay)
        .where('DateTime', isLessThanOrEqualTo: lastDay)
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
      body: ListView(
        children: [
            TableCalendar(
              eventLoader: _getEventsForTheDay,
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
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
                setState(() {
                  _focusedDay = focusedDay;
                });
                _loadFirestoreEvents();
              },
            ),
          ..._getEventsForTheDay(_selectedDay!).map(
                (event) => ListTile(
              title: Text(
                event.name,
              ),
              subtitle: Text(
                event.date.toString(),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapScreen(exams: _events.values.expand((e)=>e).toList()),
                    )
                );
              },
              child: Text('Go to Map')
          )
          ],
        ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                  builder: (_) => AddExam(
                      firstDate: _firstDay,
                      lastDate: _lastDay,
                      selectedDate: _selectedDay,
                  ),
              ),
            );
            if(result ?? false) {
              _loadFirestoreEvents();
            }
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}