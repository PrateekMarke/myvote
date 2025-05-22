import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvote/candidate/candidate_content.dart';
import 'package:myvote/showEvents.dart';
import 'package:myvote/resultpage.dart';

class CandidateHomePage extends StatefulWidget {
  @override
  _CandidateHomePageState createState() => _CandidateHomePageState();
}

class _CandidateHomePageState extends State<CandidateHomePage> {
  int _selectedIndex = 0;
  String? userRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && data['role'] != null) {
        setState(() {
          userRole = data['role'];
          isLoading = false;
        });
      } else {
        setState(() {
          userRole = 'unknown';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        userRole = 'unknown';
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> _pages = [
      CandidateHomeContent(),
      ShowEventsPage(userRole: userRole!), // 💡 now passed safely
      ResultsPage(),
    ];

    final List<String> _titles = [
      "Candidate Home",
      "Show Events",
      "Results",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Results'),
        ],
      ),
    );
  }
}
