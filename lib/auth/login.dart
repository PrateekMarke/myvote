import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:myvote/core/utils/widgets/customelavatedbutton.dart';
import 'package:myvote/core/utils/widgets/customtextfield.dart';
import 'package:myvote/core/utils/widgets/validator.dart';

import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  void loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = doc['role'];

      switch (role) {
        case 'student':
          context.go('/studentDashboard');
          break;
        case 'manager':
          context.go('/managerDashboard');
          break;
        case 'candidate':
          context.go('/candidateRegister');
          break;
        default:
          showError("No valid role assigned.");
      }
    } catch (e) {
      showError("Login failed: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login as ${widget.role.toUpperCase()}")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => evalEmail(value),
                  ),
                  const SizedBox(height: 12),

                  CustomTextField(
                    label: "Password",
                    controller: passwordController,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon:
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                    obscureText: !isPasswordVisible,
                    onSuffixPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    validator:
                        (value) => emptyFieldValidator(value, "Password"),
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomElevatedButton(
                        text: 'Login',
                        onPressed: loginUser,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
