import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/widgets/ad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/hero_card.dart';
import '../widgets/transadd.dart';
import '../widgets/transcard.dart';
import 'login.dart';

class Homesc extends StatefulWidget {
  const Homesc({super.key, this.theme});
  final theme;
  @override
  State<Homesc> createState() => _HomescState();
}
class _HomescState extends State<Homesc> {

  final userde=FirebaseAuth.instance.currentUser!.uid;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  _dialogbuilder(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content:Addtrans(),
      );
    });
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
        return Text('Hello, $username',style: TextStyle(color: Colors.white));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme=widget.theme;
    return Scaffold(
      backgroundColor: theme==false?Colors.white:Colors.grey.shade800,
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogbuilder(context);
        },
        child: Icon(Icons.add,color: Colors.white,)
        ,backgroundColor: Colors.blue.shade900,),
      // appBar: AppBar(
      //   title: _buildUsername(),
      //   backgroundColor: Colors.blue.shade900,
      //   // automaticallyImplyLeading: false,
      //   iconTheme: IconThemeData(color: Colors.white),
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue.shade900,
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //               Text('Expense Tracker',style: TextStyle(color: Colors.white,fontSize: 30),)
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         title: Text('Profile'),
      //         onTap: () {
      //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Dashboard'),
      //         onTap: () {
      //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
      //         },
      //       ),
      //       TextButton(
      //           onPressed: (){
      //           },
      //           child: Row(
      //             children: [
      //               Icon(Icons.sunny,color: Colors.black,),
      //               Text('  Theme',style: TextStyle(color: Colors.black),)
      //             ],
      //           )
      //       ),
      //       TextButton(
      //           onPressed: (){
      //             logout();
      //           },
      //           child: Row(
      //             children: [
      //               Icon(Icons.logout,color: Colors.black,),
      //               Text('  Logout',style: TextStyle(color: Colors.black),)
      //             ],
      //           )
      //       ),
      //
      //       // Add more options as needed
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Maincard(userid: userde,theme:theme,),
            Transcard(theme: theme,),
            AdMobBanner()
          ],
        ),
      ),
    );
  }
}

