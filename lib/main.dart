import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myvote/admin/admin_home.dart';

import 'package:myvote/candidate/registration.dart';
import 'package:myvote/login.dart';
import 'package:myvote/student/student_home.dart';

import 'package:myvote/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
routes: {
  '/': (context) => WelcomePage(),
  '/candidateRegister': (context) => CandidateRegisterPage(),
  '/studentDashboard': (context) => StudentDashboard(),
  '/managerDashboard': (context) => ManagerDashboard(),
  
},
onGenerateRoute: (settings) {
  if (settings.name == '/login') {
    return MaterialPageRoute(builder: (_) => LoginPage());
  }
  return null;
},

);

  }
}

