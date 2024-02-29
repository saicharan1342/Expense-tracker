import 'dart:async';
import 'package:expensetracker/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEailState();
}

class _VerifyEailState extends State<VerifyEmail> {
  final auth=FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState

    user=auth.currentUser!;
    user.sendEmailVerification();
    timer=Timer.periodic(Duration(seconds: 2), (timer) {
      isEmailverified();
    });

    super.initState();

  }
  void dispose(){
    timer.cancel();
    super.dispose();


  }


  Future<void> isEmailverified()async {
    user=auth.currentUser!;
    await user.reload();
    if(user.emailVerified)
      {
        timer.cancel();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
      }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
          },
          icon: Icon(Icons.arrow_back), // Wrap Icons.arrow_back with Icon widget
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text("Verification mail is sent to ${user.email} please verify"),
        ),
      ),
    );
  }
}
