import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateVotingEventPage extends StatefulWidget {
  @override
  _CreateVotingEventPageState createState() => _CreateVotingEventPageState();
}

class _CreateVotingEventPageState extends State<CreateVotingEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final _candidateCountController = TextEditingController();
  final _voterCountController = TextEditingController();
  final _rulesController = TextEditingController();

  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final _firestore = FirebaseFirestore.instance;

    Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }


Future<void> _submitForm() async {
  if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
    final DateTime startTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final DateTime endTime = startTime.add(Duration(
      minutes: int.tryParse(_timeLimitController.text.trim()) ?? 30,
    ));

    final eventData = {
      'eventName': _eventNameController.text.trim(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'candidates': int.tryParse(_candidateCountController.text.trim()) ?? 0,
      'voters': int.tryParse(_voterCountController.text.trim()) ?? 0,
      'rules': _rulesController.text.trim(),
      'createdAt': Timestamp.now(),
    };

    try {
      await _firestore.collection('voting_events').add(eventData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Voting event created')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Failed to create event')));
    }
  }
}


  @override
  void dispose() {
    _eventNameController.dispose();
    _timeLimitController.dispose();
    _candidateCountController.dispose();
    _voterCountController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final formattedDate = _selectedDate != null
        ? DateFormat.yMMMd().format(_selectedDate!)
        : "Select Date";
    final formattedTime = _selectedTime != null
        ? _selectedTime!.format(context)
        : "Select Time";
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: "Event Name"),
                validator: (value) => value!.isEmpty ? "Enter event name" : null,
              ),
         
                 SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickDate,
                    child: Text(formattedDate),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(formattedTime),
                  ),
                ),
              ],
            ),
              TextFormField(
                controller: _candidateCountController,
                decoration: InputDecoration(labelText: "Number of Candidates"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter candidate count" : null,
              ),
              TextFormField(
                controller: _voterCountController,
                decoration: InputDecoration(labelText: "Number of Voters"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter voter count" : null,
              ),
              TextFormField(
                controller: _rulesController,
                decoration: InputDecoration(labelText: "Rules"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Enter rules" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Create Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
