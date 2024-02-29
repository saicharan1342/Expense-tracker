import 'package:flutter/material.dart';

import '../utils/iconlist.dart';

class Catedrop extends StatelessWidget {
  const Catedrop({super.key, this.cattype, required this.onChanged});
  final String? cattype;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    var appic=Appicons();
    return DropdownButton<String>(
      value: cattype,
        isExpanded: true,
        hint: Text(cattype??'Select Category'),
        items: appic.homeexpense.map((e) => DropdownMenuItem<String>(value:e['name'],child: Row(
          children: [
            Icon(
              e['icon'],
              color: Colors.black45,
            ),
            SizedBox(
              width: 10,
            ),
            Text(e['name'],style: TextStyle(color: Colors.black45),),
          ],
        ))).toList(),
        onChanged:onChanged
    );
  }
}
