import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          "Welcome, Student!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
