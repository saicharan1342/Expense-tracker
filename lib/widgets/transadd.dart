import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../utils/validator.dart';
import 'categorydrop.dart';

class Addtrans extends StatefulWidget {
  const Addtrans({Key? key});

  @override
  State<Addtrans> createState() => _AddtransState();
}

class _AddtransState extends State<Addtrans> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var type = 'Credit';
  var categ = "others";
  var isloader = false;
  var amounteditcon = TextEditingController();
  var titleeditcon = TextEditingController();
  late DateTime selectedDateTime;
  var uid = Uuid();

  int timestamp = DateTime.now().microsecondsSinceEpoch;

  Future<void> _submitf() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isloader = true;
      });

      final user = FirebaseAuth.instance.currentUser;

      var amount = double.parse(amounteditcon.text);
      var id = uid.v4();

      String monthyear = DateFormat('MMM y').format(DateTime.now());
      final userdoc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      double remainamo = 0.0;
      double totalc = 0.0;
      double totald = 0.0;

      final transactionsQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transaction')
          .orderBy('timestamp', descending: true)
          .get();
      if(transactionsQuery.docs.isNotEmpty){
        for(int i=0;i<transactionsQuery.docs.length;i++){
          var dd=transactionsQuery.docs[i];
          if(dd['timestamp']>timestamp){
            double bal=dd['balance'];
            double totc=dd['totalc'];
            double totd=dd['totald'];
            if(type=='Credit'){
              bal+=amount;
              totc+=amount;

            }
            else{
              bal-=amount;
              totd+=amount;
            }
            await dd.reference.update({'balance': bal,'totalc':totc,'totald':totd});

          }
          else{
            if(dd['timestamp']<timestamp ){
                remainamo=dd['balance'];
                totalc=dd['totalc'];
                totald=dd['totald'];
                break;
            }
          }
        }

      }
      else{
        double remainamo = userdoc['balance'];
        double totalc = userdoc['totalc'];
        double totald = userdoc['totald'];
      }

      if (type == 'Credit') {
        remainamo += amount;
        totalc += amount;
      } else {
        remainamo -= amount;
        totald += amount;
      }



      var data = {
        "Dateoftrans": DateFormat('dd-MM-yyyy HH:mm').format(selectedDateTime),
        "id": id,
        "title": titleeditcon.text,
        "amount": amount,
        "type": type,
        "timestamp": timestamp,
        "totalc": totalc,
        "totald": totald,
        "balance": remainamo,
        "monthyear": DateFormat('MMM yyyy').format(selectedDateTime),
        "category": categ,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transaction')
          .doc(id)
          .set(data);
      final transactionsQuery1 = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transaction')
          .orderBy('timestamp', descending: true)
          .get();
      if(transactionsQuery1.docs.isNotEmpty){
        var dd=transactionsQuery1.docs[0];
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'totald': dd['totald'],
          'balance': dd['balance'],
          'totalc': dd['totalc'],
          'updatedAt': timestamp,
        });
      }
      Navigator.pop(context);
      setState(() {
        isloader = false;
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          timestamp = selectedDateTime.microsecondsSinceEpoch;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var appvalid = Appvalidator();
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: titleeditcon,
              validator: appvalid.isEmptycheck,
              autovalidateMode: AutovalidateMode.always,
              decoration: InputDecoration(label: Text('Title')),
            ),
            TextFormField(
              controller: amounteditcon,
              validator: appvalid.isEmptycheck,
              autovalidateMode: AutovalidateMode.always,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(label: Text('Amount')),
            ),
            Catedrop(
              cattype: categ,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    categ = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
              value: 'Credit',
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () => _selectDateTime(context),
                child: Text('${DateFormat('dd-MM-yyyy HH:mm').format(selectedDateTime)}'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  isloader ? "" : _submitf();
                },
                child: isloader
                    ? Center(child: CircularProgressIndicator())
                    : Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
