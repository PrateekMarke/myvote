import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


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
              final event = events[index];
              final eventName = event['eventName'];

              // Safe parsing startTime and endTime strings
              final String? startTimeString =
                  event.data().toString().contains('startTime') ? event['startTime'] : null;
              final String? endTimeString =
                  event.data().toString().contains('endTime') ? event['endTime'] : null;

              DateTime? startTime;
              DateTime? endTime;

              if (startTimeString != null) startTime = DateTime.tryParse(startTimeString);
              if (endTimeString != null) endTime = DateTime.tryParse(endTimeString);

              final now = DateTime.now();

              final bool hasStarted = startTime != null ? now.isAfter(startTime) : false;
              final bool hasEnded = endTime != null ? now.isAfter(endTime) : false;

              final formattedEnd = endTime != null
                  ? DateFormat('MMM d, yyyy – h:mm a').format(endTime)
                  : 'Unknown end time';

              Widget card = Opacity(
                opacity: hasEnded ? 0.5 : 1,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventName,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 16),
                            SizedBox(width: 6),
                            Expanded(
                              child: (startTime != null && endTime != null)
                                  ? hasStarted && !hasEnded
                                      ? StreamBuilder(
                                          stream: Stream.periodic(Duration(seconds: 1)),
                                          builder: (_, __) {
                                            final updatedNow = DateTime.now();
                                            final remaining = endTime!.difference(updatedNow);
                                            if (remaining.isNegative) {
                                              return Text("⏰ Voting has ended",
                                                  style: TextStyle(color: Colors.red));
                                            }
                                            final mins = remaining.inMinutes.remainder(60);
                                            final secs = remaining.inSeconds.remainder(60);
                                            return Text(
                                              "⏳ Ends in ${remaining.inHours}h ${mins}m ${secs}s",
                                              style: TextStyle(color: Colors.green),
                                            );
                                          },
                                        )
                                      : Text(
                                          hasEnded
                                              ? "🛑 Voting ended on $formattedEnd"
                                              : "⏱ Voting starts at ${DateFormat.jm().format(startTime)}",
                                          style: TextStyle(color: Colors.orange),
                                        )
                                  : Text("ℹ️ Event time info not available",
                                      style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );


              final bool canTap =
                  (userRole == 'manager' || userRole == 'candidate') || (userRole == 'student' && !hasEnded);

              return InkWell(
               onTap: canTap
    ? () {
        if (userRole == 'manager') {
          context.push(
            '/event-details/${event.id}',
            extra: eventName,
          );
        } else if (userRole == 'candidate') {
          context.push(
            '/candidate-enroll/${event.id}',
            extra: {
              'eventName': eventName,
              'rules': event['rules'] ?? 'No rules specified.',
            },
          );
        } else if (userRole == 'student') {
          context.push(
            '/student-voting/${event.id}',
            extra: eventName,
          );
        }
      }
    : null,

                child: AbsorbPointer(
                  absorbing: !canTap,
                  child: card,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
