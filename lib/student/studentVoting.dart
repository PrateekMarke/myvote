// StudentVotingPage
import 'package:flutter/material.dart';

class StudentVotingPage extends StatelessWidget {
  final String eventId;
  final String eventName;

  StudentVotingPage({required this.eventId, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vote Now")),
      body: Center(child: Text("Voting page for: $eventName")),
    );
  }
}