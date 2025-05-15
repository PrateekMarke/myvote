import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  @override
  State<UserManagementPage> createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRole = 'student';
  bool isCreating = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> createUser() async {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Create New User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            DropdownButton<String>(
              value: _selectedRole,
              items: ['student', 'manager', 'candidate'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
              }).toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
            SizedBox(height: 20),
            isCreating
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: createUser,
                    child: Text("Create User"),
                  ),
            SizedBox(height: 30),
            Text("All Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Text("No users found");

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final email = user['email'];
                    final role = user['role'];
                    final name = user.data().toString().contains('name') ? user['name'] : '';

                    return ListTile(
                      title: Text(name.isEmpty ? email : name),
                      subtitle: Text("Email: $email\nRole: $role"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showUpdateDialog(user),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteUser(user.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
