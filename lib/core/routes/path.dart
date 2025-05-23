import 'package:go_router/go_router.dart';
import 'package:myvote/admin/admin_home.dart';
import 'package:myvote/auth/login.dart';
import 'package:myvote/auth/welcome.dart';
import 'package:myvote/candidate/candidate_home.dart';
import 'package:myvote/candidate/registration.dart';
import 'package:myvote/student/student_home.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'unknown';
        return LoginPage(role: role); 
      },
    ),
    GoRoute(path: '/candidateHome', builder: (context, state) => CandidateHomePage()),
    GoRoute(path: '/candidateRegister', builder: (context, state) => CandidateRegistrationPage()),
    GoRoute(path: '/studentDashboard', builder: (context, state) => StudentDashboard()),
    GoRoute(path: '/managerDashboard', builder: (context, state) => ManagerDashboard()),
  ],
);



