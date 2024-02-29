
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'applock.dart';

class Settin extends StatefulWidget {
  const Settin({Key? key, required this.theme}) : super(key: key);
  final bool theme;

  @override
  State<Settin> createState() => _SettinState();
}

class _SettinState extends State<Settin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme ? Colors.grey.shade800 : Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Applock(theme: widget.theme)));
          },
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.lock,
                  color: widget.theme ? Colors.white : Colors.black,
                ),
                SizedBox(width: 16),
                Text(
                  'App lock',
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.theme ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: widget.theme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
