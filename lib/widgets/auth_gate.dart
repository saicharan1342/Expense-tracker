import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard.dart';
import '../screens/login.dart';
import '../screens/pinlogin.dart';
import '../screens/verify.dart';

class Authgate extends StatefulWidget {
  const Authgate({Key? key}) : super(key: key);

  @override
  State<Authgate> createState() => _AuthgateState();
}

class _AuthgateState extends State<Authgate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        User? user = snapshot.data;
        if (user == null) {
          return const Login();
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('users').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (!snapshot.hasData) {
              // Handle case where snapshot has no data
              return const Login(); // or any other appropriate widget
            }

            var data = snapshot.data!.data(); // Extract data from DocumentSnapshot
            if (data == null || !user.emailVerified) {
              // Handle case where data is null or email is not verified
              return VerifyEmail(); // or any other appropriate widget
            }

            if (data['mpinon'] == true) {
              return PinLoginScreen();
            } else {
              return Dashboard(); // or any other appropriate widget
            }
          },
        );
      },
    );
  }
}
