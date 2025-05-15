import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final _firestore = FirebaseFirestore.instance;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final eventData = {
        'eventName': _eventNameController.text.trim(),
        'timeLimit': int.tryParse(_timeLimitController.text.trim()) ?? 0,
        'candidates': int.tryParse(_candidateCountController.text.trim()) ?? 0,
        'voters': int.tryParse(_voterCountController.text.trim()) ?? 0,
        'rules': _rulesController.text.trim(),
        'createdAt': Timestamp.now(),
      };

      try {
        await _firestore.collection('voting_events').add(eventData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Voting event created')));
        Navigator.pop(context);
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
              TextFormField(
                controller: _timeLimitController,
                decoration: InputDecoration(labelText: "Time Limit (in minutes)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter time limit" : null,
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
