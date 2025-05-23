import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvote/core/utils/widgets/customelavatedbutton.dart';
import 'package:myvote/core/utils/widgets/customtextfield.dart';
import 'package:myvote/core/utils/widgets/validator.dart';


class CandidateRegistrationPage extends StatefulWidget {
  @override
  _CandidateRegistrationPageState createState() => _CandidateRegistrationPageState();
}

class _CandidateRegistrationPageState extends State<CandidateRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? name;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkCandidateAlreadyRegistered();
  }

  Future<void> checkCandidateAlreadyRegistered() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final candidateDoc = await FirebaseFirestore.instance.collection('candidates').doc(uid).get();

    if (candidateDoc.exists) {
      context.go('/candidateHome');
    } else {
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          name = doc['name'];
          email = doc['email'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User data not found.")));
      }
    }
  }

  Future<void> submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('candidates').doc(uid).set({
      'name': name,
      'email': email,
      'studentId': _studentIdController.text.trim(),
      'department': _departmentController.text.trim(),
      'year': _yearController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    context.go('/candidateHome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Candidate Registration")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text("Name: $name", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text("Email: $email", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        CustomTextField(
                          controller: _studentIdController,
                          label: 'Student ID',
                          validator: (value) => emptyFieldValidator(value, 'Student ID'),
                        ),
                        SizedBox(height: 12),
                        CustomTextField(
                          controller: _departmentController,
                          label: 'Department',
                          validator: (value) => emptyFieldValidator(value, 'Department'),
                        ),
                        SizedBox(height: 12),
                        CustomTextField(
                          controller: _yearController,
                          label: 'Year',
                          validator: (value) => emptyFieldValidator(value, 'Year'),
                        ),
                        SizedBox(height: 12),
                        CustomTextField(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          validator: (value) => evalPhone(value)
                        ),
                        SizedBox(height: 20),
                        CustomElevatedButton(
                          text: "Submit",
                          onPressed: submitRegistration,
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
