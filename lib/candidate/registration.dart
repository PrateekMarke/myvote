import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'candidate_home.dart'; // Your candidate home page

class CandidateRegistrationPage extends StatefulWidget {
  @override
  _CandidateRegistrationPageState createState() => _CandidateRegistrationPageState();
}

class _CandidateRegistrationPageState extends State<CandidateRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? name;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkCandidateAlreadyRegistered();
  }

  Future<void> checkCandidateAlreadyRegistered() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final candidateDoc = await FirebaseFirestore.instance.collection('candidates').doc(uid).get();

    if (candidateDoc.exists) {
      // Candidate already registered, redirect to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CandidateHomePage()),
      );
    } else {
      // Proceed with registration
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          name = doc['name'];
          email = doc['email'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User data not found.")));
      }
    }
  }

  Future<void> submitRegistration() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('candidates').doc(uid).set({
      'name': name,
      'email': email,
      'studentId': _studentIdController.text.trim(),
      'department': _departmentController.text.trim(),
      'year': _yearController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CandidateHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Candidate Registration")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text("Name: $name", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Email: $email", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _studentIdController,
                      decoration: InputDecoration(labelText: 'Student ID'),
                      validator: (value) => value!.isEmpty ? 'Enter Student ID' : null,
                    ),
                    TextFormField(
                      controller: _departmentController,
                      decoration: InputDecoration(labelText: 'Department'),
                      validator: (value) => value!.isEmpty ? 'Enter Department' : null,
                    ),
                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Year'),
                      validator: (value) => value!.isEmpty ? 'Enter Year' : null,
                    ),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Enter Mobile Number' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submitRegistration();
                        }
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
