

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db{
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(data,context) async {
    final userde=FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userde)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text(''),
              content: Text(''),
            );
          });
    });
  }
}