import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
 
void loginUser() async {
  setState(() => isLoading = true);
  try {
    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final uid = userCredential.user!.uid;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final role = doc['role'];

    if (role == 'student') {
      Navigator.pushReplacementNamed(context, '/studentDashboard');
    } else if (role == 'manager') {
      Navigator.pushReplacementNamed(context, '/managerDashboard');
    }else if (role == 'candidate') {
      Navigator.pushReplacementNamed(context, '/candidateRegister');
    } 
    else {
      showError("No valid role assigned");
    }
  } catch (e) {
    showError("Login failed: ${e.toString()}");
  } finally {
    setState(() => isLoading = false);
  }
}




  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voting App Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 10),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: loginUser,
                    child: Text("Login"),
                  )
          ],
        ),
      ),
    );
  }
}
