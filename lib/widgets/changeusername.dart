import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Usernamechange extends StatefulWidget {
  final VoidCallback onUsernameChanged;

  const Usernamechange({Key? key, required this.onUsernameChanged}) : super(key: key);

  @override
  State<Usernamechange> createState() => _UsernamechangeState();
}

class _UsernamechangeState extends State<Usernamechange> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('users').doc(_userId).update({'username': _usernameController.text});
        widget.onUsernameChanged(); // Notify parent widget about the change
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update username: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(label: Text('Enter new username')),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading ? CircularProgressIndicator() : Text("Change username"),
            ),
          ],
        ),
      ),
    );
  }
}
