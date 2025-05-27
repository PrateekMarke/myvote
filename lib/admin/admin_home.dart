import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvote/admin/CreateEventPage.dart';
import 'package:myvote/admin/userManagement.dart';
import 'package:myvote/core/utils/widgets/custom_butto,m_nav.dart';

import '../resultpageList.dart';
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
   ResultListPage(),               
  ];

  final List<BottomNavItem> _navItems = [
  BottomNavItem(icon: Icons.home, label: "Home"),
  BottomNavItem(icon: Icons.event_seat_rounded, label: "Create Event"),
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