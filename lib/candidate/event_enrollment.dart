import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CandidateEnrollmentPage extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String rules;

  const CandidateEnrollmentPage({
    required this.eventId,
    required this.eventName,
    required this.rules,
  });

  @override
  _CandidateEnrollmentPageState createState() => _CandidateEnrollmentPageState();
}

class _CandidateEnrollmentPageState extends State<CandidateEnrollmentPage> {
  bool _isLoading = false;
  bool _isEnrolled = false;

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _userData = data;
        });
        _checkEnrollment(user.uid);
      }
    }
  }

  Future<void> _checkEnrollment(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .where('eventId', isEqualTo: widget.eventId)
        .where('email', isEqualTo: _userData?['email'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() => _isEnrolled = true);
    }
  }

void _enrollCandidate() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final candidateSnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (candidateSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate profile not found.')),
      );
      return;
    }

    final candidateData = candidateSnapshot.docs.first.data();

    // Save enrollment entry (you can reuse the same 'candidates' collection, or create a subcollection under event)
  await FirebaseFirestore.instance
    .collection('event_enrollments')
    .doc(widget.eventId)
    .collection('candidates')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .set({
  'candidateId': candidateSnapshot.docs.first.id, // ID from candidates collection
  'name': candidateData['name'],
  'email': candidateData['email'],
  'timestamp': FieldValue.serverTimestamp(),
});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully enrolled in the event!')),
    );
  } catch (e) {
    print('Enrollment Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enrollment failed. Please try again.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Enroll in Event")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Enroll in Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Event: ${widget.eventName}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Rules:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(widget.rules, style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            if (_isEnrolled)
              Text("You are already enrolled in this event.", style: TextStyle(color: Colors.green, fontSize: 16)),
            if (!_isEnrolled)
              ElevatedButton(
                onPressed: _isLoading ? null : _enrollCandidate,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Enroll Now"),
              ),
          ],
        ),
      ),
    );
  }
}
