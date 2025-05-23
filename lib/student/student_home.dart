import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvote/core/utils/widgets/custom_buttom_nav.dart';
import 'package:myvote/resultpage.dart';
import 'package:myvote/showEvents.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ShowEventsPage(userRole: 'student'),
    ResultsPage(),
  ];

  final List<BottomNavItem> _navItems = [
    BottomNavItem(icon: Icons.event, label: "Events"),
    BottomNavItem(icon: Icons.bar_chart, label: "Results"),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navItems[_selectedIndex].label),
        automaticallyImplyLeading: false,
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
