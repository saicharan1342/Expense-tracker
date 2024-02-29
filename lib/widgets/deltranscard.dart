import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../utils/iconlist.dart';
import 'categorydrop.dart';

class DTransactionCard extends StatefulWidget {
  const DTransactionCard({
    Key? key,
    required this.appic,
    required this.data,
    required this.onDismiss,
    required this.theme, required this.onrecover,
  }) : super(key: key);

  final bool theme;
  final Appicons appic;
  final QueryDocumentSnapshot<Object?> data;
  final Function(QueryDocumentSnapshot<Object?>) onDismiss;
  final Function(QueryDocumentSnapshot<Object?>) onrecover;

  @override
  State<DTransactionCard> createState() => _DTransactionCardState();
}

class _DTransactionCardState extends State<DTransactionCard> {
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(widget.data['timestamp'] as int);
    String datef = DateFormat('dd MMM yyyy hh:mma').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.theme ? Colors.grey.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.grey.withOpacity(0.09),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            )
          ],
        ),
        child: Dismissible(
          key: Key(widget.data.id),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {},
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (context) {
                if(direction==DismissDirection.endToStart){
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Are you sure? Delete permanantly'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  widget.onDismiss(widget.data);
                                  Navigator.pop(context);
                                },
                                child: Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else{
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Recover this transaction'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  //onrecover(data);
                                  Navigator.pop(context);
                                },
                                child: Text('Recover'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
          background: Container(
            color: Colors.green,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  child: Icon(
                    Icons.restore,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          child: ListTile(
            minVerticalPadding: 3,
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            leading: Container(
              width: 60,
              height: 100,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.data["type"] == 'Credit'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                ),
                child: Center(
                  child: FaIcon(
                    widget.appic.getexpensecat(widget.data["category"] as String),
                    color: widget.data["type"] == 'Credit' ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.data["title"]}',
                    style: TextStyle(color: widget.theme ? Colors.white : Colors.black),
                  ),
                ),
                Text(
                  '${widget.data["type"] == 'Credit' ? "+" : "-"} ₹${widget.data["amount"].toStringAsFixed(2)}',
                  style: TextStyle(color: widget.data["type"] == 'Credit' ? Colors.green : Colors.red.shade900),
                )
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Spacer(),
                    Text(
                      '₹${widget.data["balance"].toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
                Text(
                  '${widget.data['Dateoftrans']}',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
