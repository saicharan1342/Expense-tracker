import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/changepass.dart';
import '../widgets/changeusername.dart';
import 'login.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.theme}) : super(key: key);
  final theme;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  _showChangeUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Usernamechange(
          onUsernameChanged: () {
            setState(() {
              // Refresh user information after username change
            });
          },
        ),
      ),
    );
  }
  var islogout=false;

  logout() async {
    setState(() {
      islogout=true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    setState(() {
      islogout=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme==false?Colors.white:Colors.grey.shade800,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color:  Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Icon(Icons.person, size: 150,color: widget.theme==false?Colors.black:Colors.white,),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('User not found');
                    }
                    final data = snapshot.data!;
                    final username = data['username'];
                    final email = data['email'];
                    final phone = data['phone'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Username: $username', style: TextStyle(color: widget.theme==false?Colors.black:Colors.white, fontSize: 25)),
                        Text('Email: $email', style: TextStyle(color: widget.theme==false?Colors.black:Colors.white, fontSize: 25)),
                        Text('Phone: $phone', style: TextStyle(color: widget.theme==false?Colors.black:Colors.white, fontSize: 25)),
                      ],
                    );
                  },
                ),
                TextButton(
                  onPressed: () => _showChangeUsernameDialog(context),
                  child: Text(
                    "Change Username",
                    style: TextStyle(color: Colors.blue.shade500, decoration: TextDecoration.underline, fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content: Changepassword(),
                      );
                    });
                  },
                  child: Text(
                    "Change Password",
                    style: TextStyle(color: Colors.blue.shade500, decoration: TextDecoration.underline, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
