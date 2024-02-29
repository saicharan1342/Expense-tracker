import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/widgets/trans_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Tabbarview extends StatefulWidget {
  const Tabbarview({Key? key, required this.cate, required this.monyear, required this.theme});
  final String cate;
  final String monyear;
  final bool theme;

  @override
  State<Tabbarview> createState() => _TabbarviewState();
}

class _TabbarviewState extends State<Tabbarview> {

  double credit = 0;
  double debit = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection("transaction")
        .orderBy('timestamp', descending: true)
        .where('monthyear', isEqualTo: widget.monyear)
        .where('category', isEqualTo: widget.cate);

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    double totalCredit = 0;
    double totalDebit = 0;

    querySnapshot.docs.forEach((doc) {
      final Map<String, dynamic> data = doc.data();
      if (data['type'] == 'Credit') {
        totalCredit += data['amount'];
      } else {
        totalDebit += data['amount'];
      }
    });

    setState(() {
      credit = totalCredit;
      debit = totalDebit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(tabs: [
              Tab(child: Column(
                children: [
                  Text('Credit', style: TextStyle(color: widget.theme?Colors.white:Colors.black)),
                  //Text('${credit.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
                ],
              )),
              Tab(child: Column(
                children: [
                  Text('Debit', style: TextStyle(color: widget.theme?Colors.white:Colors.black)),
                  //Text('${debit.toStringAsFixed(2)}', style: TextStyle(color: Colors.red)),
                ],
              )),
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  TransListView(category: widget.cate, monthyear: widget.monyear, type: 'Credit', theme: widget.theme,),
                  TransListView(category: widget.cate, monthyear: widget.monyear, type: 'Debit', theme: widget.theme,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
