
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/dashboard.dart';
import '../screens/verify.dart';
import 'db.dart';

class AuthService{
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  var db=Db();
  createuser(data,context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      await db.addUser(data, context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const VerifyEmail()));
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text('Created Successfully'),
          content: const Text('Account Created'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        );
      });
    }  catch (e) {
      showDialog(context: context, builder: (context){
          return AlertDialog(
            title: const Text('Failed '),
            content: Text(e.toString()),
          );
      });
    }
  }
  signin(data,context) async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data['email'],
          password: data['password']
      );
      // Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Dashboard()));
      // Navigator.pushReplacementNamed(context, '\Dashboard');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        showDialog(context: context, builder: (context){
          return const AlertDialog(
            title: Text('Not Found'),
            content: Text('Email Doesnot Exist'),
          );
        });
      } else if (e.code == 'wrong-password') {
        showDialog(context: context, builder: (context){
          return const AlertDialog(
            title: Text('Incorrect '),
            content: Text('Enter valid Credentials'),
          );
        });
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user already exists in Firestore
      final userDoc = await users.doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        // If user does not exist, add them to Firestore with default values
        await users.doc(userCredential.user!.uid).set({
          'username': userCredential.user!.displayName ?? 'User',
          'email': userCredential.user!.email ?? '',
          'phone': '',
          'balance': 0.0, // Cast to double
          'totalc': 0.0, // Cast to double
          'totald': 0.0, // Cast to double
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('You have successfully signed up with Google.')),
            duration: Duration(seconds: 10),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('You have successfully signed in with Google.')),
            duration: Duration(seconds: 10),
          ),
        );
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } catch (e) {
      // Handle error
      print(e);
    }
  }
  }
