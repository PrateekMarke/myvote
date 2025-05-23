import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myvote/admin/eventdetails.dart';
import 'package:myvote/candidate/event_enrollment.dart';
import 'package:myvote/student/studentVoting.dart';

class ShowEventsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userRole;
  ShowEventsPage({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('voting_events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No voting events found."));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = snapshot.data!.docs[index];
              final eventName = event['eventName'];

              // Parse Firestore timeLimit to DateTime
              final String timeLimitString = event['timeLimit'];
              final DateTime dateTime = DateTime.parse(timeLimitString);

              // Format the date and time
              final formattedDate = DateFormat.yMMMd().format(dateTime);
              final formattedTime = DateFormat.jm().format(dateTime);
              return GestureDetector(
                onTap: () {
                 if (userRole == 'manager') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EventDetailsPage(
        eventId: event.id,
        eventName: eventName,
       
      ),
    ),
  );
} else if (userRole == 'candidate') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CandidateEnrollmentPage(eventId: event.id, eventName: eventName, rules: event['rules'] ?? 'No rules specified.',),
    ),
  );
} else if (userRole == 'student') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => StudentVotingPage(eventId: event.id, eventName: eventName),
    ),
  );
}

                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.calendar_today, size: 16),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Event ends on $formattedDate at $formattedTime",
                                style: TextStyle(fontSize: 16),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
