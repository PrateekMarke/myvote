import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ResultListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ResultListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('voting_events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventName = event['eventName'];

              final String? endTimeString =
                  event.data().toString().contains('endTime') ? event['endTime'] : null;
              DateTime? endTime =
                  endTimeString != null ? DateTime.tryParse(endTimeString) : null;
              final now = DateTime.now();
              final hasEnded = endTime != null ? now.isAfter(endTime) : false;

              final formattedEnd = endTime != null
                  ? DateFormat('MMM d, yyyy – h:mm a').format(endTime)
                  : 'Unknown end time';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                            child: (endTime != null)
                                ? hasEnded
                                    ? Text(
                                        "🛑 Voting ended on $formattedEnd",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : StreamBuilder(
                                        stream: Stream.periodic(Duration(seconds: 1)),
                                        builder: (_, __) {
                                          final updatedNow = DateTime.now();
                                          final remaining = endTime.difference(updatedNow);
                                          if (remaining.isNegative) {
                                            return Text("🛑 Voting has ended",
                                                style: TextStyle(color: Colors.red));
                                          }
                                          final mins = remaining.inMinutes.remainder(60);
                                          final secs = remaining.inSeconds.remainder(60);
                                          return Text(
                                            "⏳ Results in ${remaining.inHours}h ${mins}m ${secs}s",
                                            style: TextStyle(color: Colors.green),
                                          );
                                        },
                                      )
                                : Text("ℹ️ End time unavailable",
                                    style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: hasEnded
                              ? () {
                                  context.push(
                                    '/results/${event.id}',
                                    extra: eventName,
                                  );
                                }
                              : null,
                          child: Text("View Result"),
                        ),
                      )
                    ],
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
