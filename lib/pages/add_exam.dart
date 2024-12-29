import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddExam extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  const AddExam(
      {Key? key,
        required this.firstDate,
        required this.lastDate,
        this.selectedDate})
      : super(key: key);

  @override
  State<AddExam> createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  late DateTime _selectedDate;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Exam")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'title'),
          ),
          TextField(
            controller: _locationController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'location'),
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    final name = _titleController.text;
    final location = _locationController.text;
    if (name.isEmpty) {
      print('Name cannot be empty');
      // you can use snackbar to display erro to the user
      return;
    }
    await FirebaseFirestore.instance.collection('Exam').add({
      "Name": name,
      "Location": location,
      "DateTime": Timestamp.fromDate(_selectedDate),
    });
    if(mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}