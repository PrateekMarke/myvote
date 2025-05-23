import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvote/candidate/candidate_content.dart';
import 'package:myvote/core/utils/widgets/custom_buttom_nav.dart';
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
      ShowEventsPage(userRole: userRole!), 
      ResultsPage(),
    ];

  final List<BottomNavItem> _navItems = [
  BottomNavItem(icon: Icons.home, label: "Home"),
  BottomNavItem(icon: Icons.event, label: "Events"),
  BottomNavItem(icon: Icons.bar_chart, label: "Results"),
];

    return Scaffold(
      appBar: AppBar(
      title: Text(_navItems[_selectedIndex].label),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped, items: _navItems)
    );
  }
}
