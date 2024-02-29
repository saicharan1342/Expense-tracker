import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../utils/validator.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({Key? key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  var valid=Appvalidator();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              // obscureText: true,
              validator: valid.passvalid,
              autovalidateMode: AutovalidateMode.always,
            ),
            TextFormField(
              controller: rePasswordController,
              decoration: InputDecoration(labelText: 'Re-enter Password'),
              autovalidateMode: AutovalidateMode.always,
              // obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please re-enter your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                User user = await FirebaseAuth.instance.currentUser!;

                //Pass in the password to updatePassword.
                user.updatePassword(passwordController.text).then((_) async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid).update({
                      "password":passwordController.text
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password changed successfully, Please relogin")));
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                  print("Successfully changed password");
                }).catchError((error){
                  print("Password can't be changed" + error.toString());
                  //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                });
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
