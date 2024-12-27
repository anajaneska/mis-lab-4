import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar App"),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // Navigate to the exams list screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExamListScreen()),
              );
            },
          ),
        ],
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}

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
}