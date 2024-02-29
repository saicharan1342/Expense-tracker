
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/iconlist.dart';
import '../widgets/deltranscard.dart';
import '../widgets/transactioncard.dart';

class RecentDeleted extends StatefulWidget {
  const RecentDeleted({super.key, required this.theme});
  final bool theme;

  @override
  State<RecentDeleted> createState() => _RecentDeletedState();
}

class _RecentDeletedState extends State<RecentDeleted> {
  @override
  Widget build(BuildContext context) {
    var appic=Appicons();
    final userde=FirebaseAuth.instance.currentUser!.uid;
    Query query=FirebaseFirestore.instance.collection('users').doc(userde).collection("recyclebin").orderBy('timestamp',descending: true);

    return Scaffold(
      backgroundColor: widget.theme?Colors.grey.shade800:Colors.white,
      appBar: AppBar(
        title: Text('Recently Deleted',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<QuerySnapshot>(
            future: query.get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong',style: TextStyle(color: widget.theme?Colors.white:Colors.black),);
              }

              else if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading",style: TextStyle(color: widget.theme?Colors.white:Colors.black));
              }
              else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                return Text("No transactions found",style: TextStyle(color: widget.theme?Colors.white:Colors.black));
              }
              var data=snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {

                  var cardData= data[index];
                  return DTransactionCard(appic: appic,theme: widget.theme, data: cardData, onDismiss: (dismisseddata) async {
                    try {
                      // Delete the dismissed transaction
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userde)
                          .collection("recyclebin")
                          .doc(cardData.id)
                          .delete();
                      print('Transaction deleted successfully');
                    } catch (error) {
                      print('Error deleting transaction: $error');
                    }
                  }, onrecover: (QueryDocumentSnapshot<Object?> data) {

                  },
                  );
                },
              );
            },
          ),

        ),
      ),
    );
  }
}
