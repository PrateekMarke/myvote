import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myvote/core/utils/widgets/customelavatedbutton.dart';
import 'package:myvote/core/utils/widgets/customtextfield.dart';
import 'package:myvote/core/utils/widgets/validator.dart';

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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Please select both date and time')),
      );
      return;
    }
    final DateTime eventDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    if (_formKey.currentState!.validate()) {
      final eventData = {
        'eventName': _eventNameController.text.trim(),
        'timeLimit': eventDateTime.toIso8601String(),
        'candidates': int.tryParse(_candidateCountController.text.trim()) ?? 0,
        'voters': int.tryParse(_voterCountController.text.trim()) ?? 0,
        'rules': _rulesController.text.trim(),
        'createdAt': Timestamp.now(),
      };

      try {
        await _firestore.collection('voting_events').add(eventData);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('✅ Voting event created')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Failed to create event')));
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
    final formattedDate =
        _selectedDate != null
            ? DateFormat.yMMMd().format(_selectedDate!)
            : "Select Date";
    final formattedTime =
        _selectedTime != null ? _selectedTime!.format(context) : "Select Time";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Create Voting Event",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _eventNameController,
                      label: "Event Name",
                      validator:
                          (value) => emptyFieldValidator(value, "Event Name"),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            text: formattedDate,
                            onPressed: _pickDate,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomElevatedButton(
                            text: formattedTime,
                            onPressed: _pickTime,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    CustomTextField(
                      controller: _candidateCountController,
                      label: "Number of Candidates",
                      keyboardType: TextInputType.number,
                      validator:
                          (value) => emptyFieldValidator(
                            value,
                            "Number of Candidates",
                          ),
                    ),
                    SizedBox(height: 12),
                    CustomTextField(
                      controller: _voterCountController,
                      label: "Number of Voters",
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              emptyFieldValidator(value, "Number of Voters"),
                    ),
                    SizedBox(height: 12),
                    CustomTextField(
                      controller: _rulesController,
                      label: "Rules",
                      maxLines: 5,
                      validator: (value) => emptyFieldValidator(value, "Rules"),
                    ),
                    SizedBox(height: 20),
                    CustomElevatedButton(
                      text: "Create Event",
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
