import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ResultPage extends StatelessWidget {
  final String eventId;
  final String eventName;

  const ResultPage({super.key, required this.eventId, required this.eventName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Results: $eventName")),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('event_enrollments')
            .doc(eventId)
            .collection('votes')
            .get(),
        builder: (context, voteSnapshot) {
          if (voteSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final votes = voteSnapshot.data?.docs ?? [];

          final Map<String, int> voteCounts = {};
          for (var vote in votes) {
            final candidateId = vote['votedFor'];
            voteCounts[candidateId] = (voteCounts[candidateId] ?? 0) + 1;
          }

          final sorted = voteCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          // final winnerId = sorted.isNotEmpty ? sorted.first.key : null;
          final int highestVote = sorted.isNotEmpty ? sorted.first.value : 0;
final List<String> winners = sorted
    .where((entry) => entry.value == highestVote)
    .map((entry) => entry.key)
    .toList();


          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('candidates').get(),
            builder: (context, candidateSnapshot) {
              if (candidateSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allCandidates = {
                for (var doc in candidateSnapshot.data!.docs) doc.id: doc['name'] ?? 'Unknown'
              };

              final Map<String, double> dataMap = {
                for (var entry in sorted)
                  allCandidates[entry.key] ?? entry.key: entry.value.toDouble()
              };

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Voting Statistics",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    if (dataMap.isNotEmpty)
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 2.2,
                        colorList: isDark
                            ? [Colors.deepPurple, Colors.cyan, Colors.amber, Colors.teal, Colors.pink]
                            : [Colors.blue, Colors.orange, Colors.red, Colors.green, Colors.purple],
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        ringStrokeWidth: 32,
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text("No votes cast yet.", style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text("Detailed Results", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    for (var entry in sorted)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(allCandidates[entry.key] ?? entry.key),
                          subtitle: Text("Votes: ${entry.value}"),
                         trailing: Icon(
  winners.contains(entry.key) ? Icons.emoji_events : Icons.person,
  color: winners.contains(entry.key) ? Colors.amber : null,
),

                        ),
                      ),
                    if (winners == null)
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("No winner determined yet.", style: TextStyle(color: Colors.red)),
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
