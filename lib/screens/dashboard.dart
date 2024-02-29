import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/screens/deleted.dart';
import 'package:expensetracker/screens/profile.dart';
import 'package:expensetracker/screens/settings.dart';
import 'package:expensetracker/screens/transactionsc.dart';
import 'package:expensetracker/widgets/ad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/navbar.dart';
import 'homescreen.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final userde = FirebaseAuth.instance.currentUser!.uid;
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadDarkTheme();
  }

  _loadDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }
  // late SharedPreferences _prefs;
  _saveDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
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

  Widget _buildUsername() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userde).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final data = snapshot.data!;
        final username = data['username'];
        return Text('Hello, $username', style: TextStyle(color: Colors.white));
      },
    );
  }

  int currind = 0;

  @override
  Widget build(BuildContext context) {
    var pageviewlist = [Homesc(theme: isDarkTheme), Transactionsc(theme: isDarkTheme)];
    return Scaffold(
      appBar: AppBar(
        title: currind == 0 ? _buildUsername() : Text("Expenses", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          color: isDarkTheme ? Colors.grey.shade800 : Colors.white,
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expense Tracker', style: TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.person, color: isDarkTheme ? Colors.white : Colors.black),
                    Text('Profile', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(theme: isDarkTheme)));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.settings, color: isDarkTheme ? Colors.white : Colors.black),
                    Text(' Settings', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Settin(theme: isDarkTheme,)));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.delete, color: isDarkTheme ? Colors.white : Colors.black),
                    Text(' Recycle Bin', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecentDeleted(theme: isDarkTheme)));
                },
              ),
              SwitchListTile(
                title: Text('Dark Theme', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                value: isDarkTheme,
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.white,
                trackColor: MaterialStateProperty.resolveWith((states) {
                  return isDarkTheme ? Colors.grey : Colors.grey.shade500;
                }),
                thumbColor: MaterialStateProperty.resolveWith((states) {
                  return isDarkTheme ? Colors.black : Colors.white;
                }),
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = value;
                  });
                  _saveDarkTheme(value);
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout, color: isDarkTheme ? Colors.white : Colors.black),
                    Text(' Logout', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                  ],
                ),
                onTap: logout,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Email: sscdev32@gmail.com'),
                        );
                      },
                    );
                  },
                  child: Text('Contact', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        theme: isDarkTheme,
        selectedIndex: currind,
        onDestinationSelected: (int value) {
          setState(() {
            currind = value;
          });
        },
      ),
      body: pageviewlist[currind],
    );
  }
}
