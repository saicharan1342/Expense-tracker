import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../utils/iconlist.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged, required this.theme});
  final ValueChanged<String?> onChanged;
  final bool theme;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var appic=Appicons();
  String currentCat = "All";
  final scrollcon=ScrollController();
  List<Map<String,dynamic>> categlist=[];
  var addcat={
    "name":"All",
    "icon":FontAwesomeIcons.cartPlus
  };

  void initState(){
    super.initState();
    setState(() {

      categlist=appic.homeexpense;
      categlist.insert(0,addcat);
    });

  }
  // scrolltoselected(){
  //   final selectedmonind=months.indexOf(currentMonth);
  //   if(selectedmonind!=-1){
  //     final scrolloff=(selectedmonind*100.0)-170;
  //     scrollcon.animateTo(scrolloff, duration: Duration(microseconds: 500), curve: Curves.ease);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: ListView.builder(
        controller: scrollcon,
        itemCount: categlist.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
          var data=categlist[index];
        return GestureDetector(
          onTap: (){
            setState(() {
              widget.onChanged(data['name']);
              currentCat=data['name'];
            });
          },
          child: Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color:currentCat==data['name']?Colors.blue.shade900: widget.theme?Colors.blue.withOpacity(0.3):Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(child: Row(
              children: [
                Icon(data['icon'],size: 15,color:currentCat==data['name']?Colors.white: widget.theme?Colors.white:Colors.blue.shade900 ,),
                SizedBox(
                  width: 10,
                ),
                Text(data['name'],style: TextStyle(color:currentCat==data['name']?Colors.white: widget.theme?Colors.white:Colors.blue.shade900 ),),
              ],
            )),
          ),
        );
      }),
    );
  }
}
