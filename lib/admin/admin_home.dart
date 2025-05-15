import 'package:flutter/material.dart';
import 'package:myvote/admin/userManagement.dart';

import 'VotingEventPage.dart';
import 'resultpage.dart';
import 'showEvents.dart';

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserManagementPage(),         // Home (User creation/listing)
    CreateVotingEventPage(),      // Create Event
    ShowEventsPage(),             // Show Events
    ResultsPage(),                // Results
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
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
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
