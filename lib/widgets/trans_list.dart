import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/widgets/transactioncard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/iconlist.dart';

class TransListView extends StatelessWidget {
  const TransListView({super.key, required this.category, required this.monthyear, required this.type, required this.theme});
  final String category;
  final String monthyear;
  final String type;
  final bool theme;
  @override
  Widget build(BuildContext context) {
    var appic=Appicons();
      final userde=FirebaseAuth.instance.currentUser!.uid;
    Query query=FirebaseFirestore.instance.collection('users').doc(userde).collection("transaction").orderBy('timestamp',descending: true).where('monthyear',isEqualTo:monthyear ).where('type',isEqualTo: type);
    if(category!='All'){
      query=query.where('category',isEqualTo: category);
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<QuerySnapshot>(
          future: query.get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong',style: TextStyle(color: theme?Colors.white:Colors.black),);
            }

            else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading",style: TextStyle(color: theme?Colors.white:Colors.black));
            }
            else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return Text("No transactions found",style: TextStyle(color: theme?Colors.white:Colors.black));
            }
            var data=snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {

                var cardData= data[index];
                return TransactionCard(appic: appic,theme: theme, data: cardData, onDismiss: (dismisseddata) async {
                  double am = cardData['amount'];
                  var ty = cardData['type'];
                  double bal = (await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userde)
                      .get())['balance'];
                  double totc = (await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userde)
                      .get())['totalc'];
                  double totd = (await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userde)
                      .get())['totald'];
                  if (ty == 'Credit') {
                    bal -= am;
                    totc -= am;
                  } else {
                    bal += am;
                    totd -= am;
                  }
                  Map<String, dynamic> transactionData = cardData.data() as Map<String, dynamic>;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userde)
                      .collection('recyclebin')
                      .doc(transactionData['id']) // Access ID from the extracted data
                      .set(transactionData);


                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userde)
                      .update({
                    "balance": bal,
                    "totalc": totc,
                    "totald": totd,
                  });
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userde)
                      .collection("transaction")
                      .doc(cardData.id)
                      .delete();
                  for (var i = 0; i < index; i++) {
                    var otherCardData = data[i];
                    // Skip the dismissed item
                    if (otherCardData.id == cardData.id) continue;

                    // Update the balance field based on the type of transaction
                    if (ty == 'Credit') {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userde)
                          .collection("transaction")
                          .doc(otherCardData.id)
                          .update({'balance': FieldValue.increment(-am),'totalc':FieldValue.increment(-am)});
                    } else {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userde)
                          .collection("transaction")
                          .doc(otherCardData.id)
                          .update({'balance': FieldValue.increment(am),'totald':FieldValue.increment(am)});
                    }
                  }
                }, onEdit: (data,val,ptype) {  },);
              },
            );
          },
        ),
      ),
    );


  }
}
