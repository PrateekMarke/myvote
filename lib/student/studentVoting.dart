import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentVotingPage extends StatefulWidget {
  final String eventId;
  final String eventName;

  StudentVotingPage({required this.eventId, required this.eventName});

  @override
  _StudentVotingPageState createState() => _StudentVotingPageState();
}

class _StudentVotingPageState extends State<StudentVotingPage> {
  List<Map<String, dynamic>> candidatesWithDetails = [];
  String? votedCandidateId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    final enrollmentSnapshot = await FirebaseFirestore.instance
        .collection('event_enrollments')
        .doc(widget.eventId)
        .collection('candidates')
        .get();

    final List<Map<String, dynamic>> enrichedCandidates = [];

    for (var doc in enrollmentSnapshot.docs) {
      final data = doc.data();
      final candidateId = doc.id;

      final fullProfile = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(candidateId)
          .get();

      enrichedCandidates.add({
        'id': candidateId,
        'name': data['name'] ?? '',
        'year': fullProfile['year'] ?? 'N/A',
        'department': fullProfile['department'] ?? 'N/A',
      });
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final voteDoc = await FirebaseFirestore.instance
        .collection('event_enrollments')
        .doc(widget.eventId)
        .collection('votes')
        .doc(userId)
        .get();

    setState(() {
      candidatesWithDetails = enrichedCandidates;
      votedCandidateId = voteDoc.exists ? voteDoc['votedFor'] : null;
      isLoading = false;
    });
  }

  Future<void> _vote(String candidateId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final voteRef = FirebaseFirestore.instance
        .collection('event_enrollments')
        .doc(widget.eventId)
        .collection('votes')
        .doc(userId);

    final existingVote = await voteRef.get();
    if (existingVote.exists) return;

    await voteRef.set({'votedFor': candidateId, 'timestamp': Timestamp.now()});

    setState(() {
      votedCandidateId = candidateId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vote for Event: ${widget.eventName}")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: candidatesWithDetails.length,
              itemBuilder: (context, index) {
                final candidate = candidatesWithDetails[index];
                final alreadyVoted = votedCandidateId != null;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(candidate['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Year: ${candidate['year']} | Dept: ${candidate['department']}"),
                    trailing: alreadyVoted
                        ? (votedCandidateId == candidate['id']
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : SizedBox.shrink())
                        : ElevatedButton(
                            child: Text("Vote"),
                            onPressed: () => _vote(candidate['id']),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
