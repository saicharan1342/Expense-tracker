import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Applock extends StatefulWidget {
  const Applock({Key? key, required this.theme}) : super(key: key);
  final bool theme;

  @override
  State<Applock> createState() => _ApplockState();
}

class _ApplockState extends State<Applock> {
  // late SharedPreferences _prefs;
  bool _applock = false;
  String _pin = '';
  final userde = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Load applock value from Firestore when the widget initializes
    _loadAppLockFromFirestore();
  }

  // Load applock value from Firestore
  // Load applock value from Firestore
  Future<void> _loadAppLockFromFirestore() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userde)
        .get();

    // Check if the 'mpinon' field exists in the document
    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      // Check if userData is not null and contains the 'mpinon' key
      if (userData != null && userData.containsKey('mpinon')) {
        setState(() {
          _applock = userData['mpinon'];
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme ? Colors.grey.shade800 : Colors.white,
      appBar: AppBar(
        title: const Text(
          'Applock',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Applock:',
              style: TextStyle(
                color: widget.theme ? Colors.white : Colors.black,
                fontSize: 20,
              ),
            ),
            trailing: Switch(
              value: _applock,
              onChanged: (value) async {
                // Update 'mpinon' field in Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userde)
                    .update({"mpinon": value});
                setState(() {
                  _applock = value;
                });
              },
            ),
          ),
          if (_applock) ...[
            ListTile(
              title: Text(
                'Set/Change PIN:',
                style: TextStyle(
                  color: widget.theme ? Colors.white : Colors.black,
                  fontSize: 20,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _showSetPinDialog();
                },
                child: Text(
                  'Set/Change',
                  style: TextStyle(
                      color: widget.theme ? Colors.black : Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSetPinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set PIN'),
          content: TextFormField(
            decoration: const InputDecoration(hintText: 'Enter PIN'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _pin = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 4) {
                return 'Pin should be 4 digits';
              } else {
                return null;
              }
            },
            autovalidateMode: AutovalidateMode.always,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Update 'mpin' field in Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userde)
                    .update({"mpin": _pin});
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }
}
