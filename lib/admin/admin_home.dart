import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvote/admin/userManagement.dart';

import 'VotingEventPage.dart';
import '../resultpage.dart';
import '../showEvents.dart';

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserManagementPage(),        
    CreateVotingEventPage(),      
    ShowEventsPage(userRole: 'manager',),            
    ResultsPage(),               
  ];

  final List<String> _titles = [
    "User Management",
    "Create Voting Event",
    "Show Events",
    "Results",
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

 @override
Widget build(BuildContext context) {
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
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create Event'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Show Events'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Results'),
      ],
    ),
  );
}
}