import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Maincard extends StatefulWidget {
  const Maincard({super.key, required this.userid, this.theme});
  final String userid;
  final theme;
  @override
  State<Maincard> createState() => _MaincardState();
}

class _MaincardState extends State<Maincard> {
  @override
  Widget build(BuildContext context) {

    var theme=widget.theme;
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance.collection('users').doc(widget.userid).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if(!snapshot.hasData || !snapshot.data!.exists){
          return Text("Document doesnot exits");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        var data=snapshot.data!.data() as Map<String,dynamic>;
        return Cards(data: data,theme: theme==false?false:true,);
      },
    );
  }
}

class Cards extends StatefulWidget {
  const Cards({
    super.key, required this.data, required this.theme,
  });
  final Map data;
  final theme;

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {

    var theme=widget.theme;
    return Container(
      color: Colors.blue.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Balance', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600, height: 1.2), textAlign: TextAlign.left),
                Text('₹${widget.data['balance'].toStringAsFixed(2)}', style: TextStyle(fontSize: 50, color: widget.data['balance']>=0?widget.data['balance']==0?Colors.white:Colors.green:Colors.red, fontWeight: FontWeight.w600, height: 1.2), textAlign: TextAlign.left),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30,bottom: 10,left: 10,right: 10),
            decoration: BoxDecoration(
                color: theme==false?Colors.white:Colors.grey.shade800,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
            ),
            child: Row(
              children: [
                CardOne(color: Colors.green, text: 'Credit', Arrow: (Icons.arrow_upward), cord:'${widget.data['totalc'].toStringAsFixed(2)}',theme: theme,),
                SizedBox(
                  width: 10,
                ),
                CardOne(color: Colors.red, text: 'Debit', Arrow: (Icons.arrow_downward), cord: '${widget.data['totald'].toStringAsFixed(2)}',theme: theme,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class CardOne extends StatelessWidget {
  const CardOne({
    super.key, required this.color, required this.text, required this.Arrow, required this.cord, this.theme,
  });
  final theme;
  final String cord;
  final Color color;
  final String text;
  final IconData Arrow;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: theme?color.withOpacity(0.5):color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text,style: TextStyle(color: color,fontSize: 17),),
                  Text("₹$cord",style: TextStyle(color: color,fontSize: 20,fontWeight: FontWeight.w600),),
                ],
              ),
              const Spacer(),
              Icon(Arrow,color: color,)
            ],
          ),
        ),
      ),
    );
  }
}
