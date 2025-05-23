import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'user_role.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void onRoleSelected(BuildContext context, String role) {
  UserRole.selectedRole = role;
  context.go('/login?role=$role'); 
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to VoteSpace", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Continue with", style: TextStyle(fontSize: 18)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => onRoleSelected(context, 'student'),
                child: Text("Student"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onRoleSelected(context, 'manager'),
                child: Text("Admin"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onRoleSelected(context, 'candidate'),
                child: Text("Candidate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}