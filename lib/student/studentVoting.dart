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
  bool hasVoted = false;
  String? votedCandidateId;
  String studentId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    checkIfVoted();
  }

  Future<void> checkIfVoted() async {
    final voteDoc = await FirebaseFirestore.instance
        .collection('votes')
        .doc(widget.eventId)
        .collection('voters')
        .doc(studentId)
        .get();

    if (voteDoc.exists) {
      setState(() {
        hasVoted = true;
        votedCandidateId = voteDoc['candidateId'];
      });
    }
  }

  Future<void> voteForCandidate(String candidateId) async {
    if (hasVoted) return;

    final eventRef = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .collection('candidates')
        .doc(candidateId);

    final voterRef = FirebaseFirestore.instance
        .collection('votes')
        .doc(widget.eventId)
        .collection('voters')
        .doc(studentId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final candidateSnapshot = await transaction.get(eventRef);
      final currentVotes = candidateSnapshot['votes'] ?? 0;

      transaction.update(eventRef, {'votes': currentVotes + 1});
      transaction.set(voterRef, {
        'candidateId': candidateId,
        'votedAt': FieldValue.serverTimestamp(),
      });
    });

    setState(() {
      hasVoted = true;
      votedCandidateId = candidateId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vote Now - ${widget.eventName}")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .collection('candidates')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text('No candidates found.'));

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final candidate = snapshot.data!.docs[index];
              final candidateId = candidate.id;
              final name = candidate['name'];
              final bio = candidate['bio'];
              final votes = candidate['votes'] ?? 0;

              final isVotedForThis = votedCandidateId == candidateId;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(bio),
                  trailing: hasVoted
                      ? (isVotedForThis
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.how_to_vote, color: Colors.grey))
                      : ElevatedButton(
                          onPressed: () => voteForCandidate(candidateId),
                          child: Text("Vote"),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
