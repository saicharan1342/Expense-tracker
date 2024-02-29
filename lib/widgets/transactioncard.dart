import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../utils/iconlist.dart';
import 'categorydrop.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.appic,
    required this.data,
    required this.onDismiss,
    required this.theme,
    required this.onEdit,
  }) : super(key: key);

  final bool theme;
  final Appicons appic;
  final QueryDocumentSnapshot<Object?> data;
  final Function(QueryDocumentSnapshot<Object?>) onDismiss;
  final Function(QueryDocumentSnapshot<Object?>, double, String) onEdit;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(data['timestamp'] as int);
    String datef = DateFormat('dd MMM yyyy hh:mma').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme ? Colors.grey.shade700 : Colors.white,
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
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit Transaction'),
                  content: ShowTrans(data: data, onEdit: onEdit),
                );
              },
            );
          },
          child: Dismissible(
            key: Key(data.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {},
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Are you sure? Move to recycle bin'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  onDismiss(data);
                                  Navigator.pop(context);
                                },
                                child: Text('Move'),
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
                },
              );
            },
            background: Container(
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
                    color: data["type"] == 'Credit'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                  ),
                  child: Center(
                    child: FaIcon(
                      appic.getexpensecat(data["category"] as String),
                      color: data["type"] == 'Credit' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${data["title"]}',
                      style: TextStyle(color: theme ? Colors.white : Colors.black),
                    ),
                  ),
                  Text(
                    '${data["type"] == 'Credit' ? "+" : "-"} ₹${data["amount"].toStringAsFixed(2)}',
                    style: TextStyle(color: data["type"] == 'Credit' ? Colors.green : Colors.red.shade900),
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
                        '₹${data["balance"].toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      )
                    ],
                  ),
                  Text(
                    '${data['Dateoftrans']}',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowTrans extends StatefulWidget {
  const ShowTrans({Key? key, required this.data, required this.onEdit})
      : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final Function(QueryDocumentSnapshot<Object?>, double, String) onEdit;

  @override
  State<ShowTrans> createState() => _ShowTransState();
}

class _ShowTransState extends State<ShowTrans> {
  late DateTime _selectedDateTime;
  late String _selectedCategory;
  late String type;
  late String ptype;
  late int timestamp;
  late double prevam;
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.data['category'] as String;
    type = widget.data['type'] as String;
    ptype = widget.data['type'] as String;
    timestamp = widget.data['timestamp'] as int;
    _selectedDateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    prevam = (widget.data['amount'] as num).toDouble();
    titleController.text = widget.data['title'] as String;
    amountController.text = (widget.data['amount'] as num).toString();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          timestamp = _selectedDateTime.microsecondsSinceEpoch;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: titleController,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            controller: amountController,
          ),
          Catedrop(
            cattype: _selectedCategory,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
          ),
          DropdownButtonFormField<String>(
            value: type,
            items: [
              DropdownMenuItem(child: Text('Credit'), value: 'Credit'),
              DropdownMenuItem(child: Text('Debit'), value: 'Debit')
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  type = value;
                });
              }
            },
          ),
          SizedBox(height: 10),
          Text('Select Date and time'),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text('${DateFormat('dd-MM-yyyy HH:mm').format(_selectedDateTime)}'),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  double currentBalance = widget.data['balance'] ?? 0.0;
                  double newAmount = double.tryParse(amountController.text) ?? 0.0;
                  double difference = newAmount - prevam;

                  if (type == 'Credit') {
                    currentBalance += difference;
                  } else {
                    currentBalance -= difference;
                  }

                  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('transaction').doc(widget.data.id).update({
                    'balance': currentBalance,
                    'type': type,
                    'category': _selectedCategory,
                    'amount': newAmount,
                    'timestamp': timestamp,
                    'title': titleController.text
                  });

                  widget.onEdit(widget.data, prevam, ptype);
                  print('Transaction edited successfully');
                  Navigator.pop(context);
                } catch (error) {
                  print('Error editing transaction: $error');
                }
              },
              child: Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }
}
