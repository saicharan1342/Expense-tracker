import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({Key? key}) : super(key: key);

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final userde = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  logout() async {
    await FirebaseAuth.instance.signOut();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userde)
        .update({
      "mpinon":false
    });
    // await _prefs.setBool('isAppLocked', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            onPressed: (){
              logout();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _controllers[i],
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _checkPin(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue.shade900, backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkPin(BuildContext context) async {
    String pin = '';
    for (int i = 0; i < 4; i++) {
      TextEditingController controller = _controllers[i];
      pin += controller.text;
    }

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userde)
        .get();

    Map<String, dynamic> data = snapshot.data()!;
    var mpin = data['mpin'];

    if (mpin == pin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      // Show error message or handle invalid PIN
    }
  }
}
