import 'package:go_router/go_router.dart';
import 'package:myvote/admin/admin_home.dart';
import 'package:myvote/admin/widgets/eventdetails.dart';
import 'package:myvote/auth/login.dart';
import 'package:myvote/auth/welcome.dart';
import 'package:myvote/candidate/candidate_home.dart';
import 'package:myvote/candidate/event_enrollment.dart';
import 'package:myvote/candidate/registration.dart';
import 'package:myvote/student/studentVoting.dart';
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

    //    GoRoute(
    //   path: '/showevent',
    //   builder: (context, state) => ShowEventsPage(userRole: 'manager'), // placeholder
    // ),
    GoRoute(
      path: '/event-details/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        final eventName = state.extra as String;
        return EventDetailsPage(eventId: eventId, eventName: eventName);
      },
    ),
    GoRoute(
      path: '/candidate-enroll/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        final extra = state.extra as Map<String, dynamic>;
        return CandidateEnrollmentPage(
          eventId: eventId,
          eventName: extra['eventName'],
          rules: extra['rules'],
        );
      },
    ),
    GoRoute(
      path: '/student-voting/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        final eventName = state.extra as String;
        return StudentVotingPage(eventId: eventId, eventName: eventName);
      },
    ),




  ],
);


