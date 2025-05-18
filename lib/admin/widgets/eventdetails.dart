import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;
  final String eventName;

  EventDetailsPage({required this.eventId, required this.eventName});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('voting_events').doc(eventId).get(),
        builder: (context, eventSnapshot) {
          if (eventSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!eventSnapshot.hasData || !eventSnapshot.data!.exists) {
            return Center(child: Text("Event not found."));
          }

          final eventData = eventSnapshot.data!;
          final rules = eventData.data().toString().contains('rules') ? eventData['rules'] : 'No rules provided.';

          // 🔁 Listen to enrolled candidates
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('event_enrollments')
                .doc(eventId)
                .collection('candidates')
                .snapshots(),
            builder: (context, candidateSnapshot) {
              if (candidateSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final candidates = candidateSnapshot.data?.docs ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Event: $eventName",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Rules:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(rules, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Text(
                      "Total Candidates: ${candidates.length}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                  Expanded(
  child: candidates.isEmpty
      ? Center(child: Text("No candidates enrolled."))
      : ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            final candidate = candidates[index];
            final name = candidate['name'] ?? 'Unnamed';
            final email = candidate['email'] ?? '';
          
            final department = candidate['department'] ?? 'N/A';
            final year = candidate['year'] ?? 'N/A';
            final mobile = candidate['mobile'] ?? 'N/A';

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Email: $email"),
             
                    Text("Department: $department"),
                    Text("Year: $year"),
                    Text("Mobile: $mobile"),
                  ],
                ),
              ),
            );
          },
        ),
)

                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
