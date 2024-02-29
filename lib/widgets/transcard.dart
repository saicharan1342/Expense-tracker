import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/widgets/transactioncard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/iconlist.dart';

class Transcard extends StatefulWidget {
  const Transcard({Key? key, required this.theme}) : super(key: key);
  final bool theme;

  @override
  State<Transcard> createState() => _TranscardState();
}

class _TranscardState extends State<Transcard> {
  @override
  Widget build(BuildContext context) {
    var appic = Appicons();
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: widget.theme ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
          RecentTrans(appic: appic, theme: widget.theme),
        ],
      ),
    );
  }
}

class RecentTrans extends StatelessWidget {
  const RecentTrans({Key? key, required this.appic, required this.theme})
      : super(key: key);

  final Appicons appic;
  final bool theme;

  @override
  Widget build(BuildContext context) {
    final userde = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userde)
          .collection("transaction")
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
            "No transactions found",
            style: TextStyle(color: theme ? Colors.white : Colors.black),
          );
        }
        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var cardData = data[index];
            return TransactionCard(
              appic: appic,
              data: cardData,
              theme: theme,
              onDismiss: (dismissedData) async {
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
              },
              onEdit: (editData, prevAmount,ptype) async {
                // await FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(userde)
                //     .collection("transaction")
                //     .doc(cardData.id)
                //     .update(editData);

              },
            );
          },
        );
      },
    );
  }
}
