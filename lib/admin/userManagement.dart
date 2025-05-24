import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvote/core/utils/widgets/custom_elevatedbutton.dart';

import 'package:myvote/core/utils/widgets/customtextfield.dart';
import 'package:myvote/core/utils/widgets/validator.dart';

class UserManagementPage extends StatefulWidget {
  @override
  State<UserManagementPage> createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRole = 'student';
  bool isCreating = false;
   bool isPasswordVisible = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;


    setState(() => isCreating = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'name': _nameController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User created successfully")));
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => isCreating = false);
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting user")));
    }
  }

  void showUpdateDialog(DocumentSnapshot user) {
    String updatedRole = user['role'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Role"),
        content: DropdownButton<String>(
          value: updatedRole,
          items: ['student', 'manager', 'candidate'].map((role) {
            return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
          }).toList(),
          onChanged: (val) => setState(() => updatedRole = val!),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _firestore.collection('users').doc(user.id).update({
                'role': updatedRole,
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Role updated")));
            },
            child: Text("Update"),
          )
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').where('role', isNotEqualTo: 'manager').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // CREATE USER FORM
          Form(
             key: _formKey,
            child: Card(
              color: isDark ? Colors.grey[850] : Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Create New User", style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 10),
                    CustomTextField(prefixIcon: const Icon(Icons.person), label: "Name", controller: _nameController, validator: (value) => emptyFieldValidator(value, "Name"),),
                    CustomTextField(prefixIcon: const Icon(Icons.email), label: "Email", controller: _emailController, keyboardType: TextInputType.emailAddress,
                    validator: (value) => evalEmail(value),),
                    CustomTextField(
                      label: "Password",
                      controller: _passwordController,
                      prefixIcon: const Icon(Icons.lock),
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
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: ['student', 'manager', 'candidate'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: "Select Role",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                    const SizedBox(height: 20),
                    isCreating
                        ? const CircularProgressIndicator()
                        : CustomElevatedButton(
                            onPressed: createUser,
                            text: "Create User",
                          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // ALL USERS LIST
          Align(
            alignment: Alignment.centerLeft,
            child: Text("All Users", style: theme.textTheme.headlineLarge),
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Text("No users found");

              final users = snapshot.data!.docs;

              return ListView.separated(
                itemCount: users.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final email = user['email'];
                  final role = user['role'];
                  final name = user.data().toString().contains('name') ? user['name'] : '';

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: isDark ? Colors.grey[900] : Colors.white,
                    elevation: 2,
                    child: ListTile(
                      title: Text(name.isEmpty ? email : name),
                      subtitle: Text("Email: $email\nRole: $role"),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showUpdateDialog(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteUser(user.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}