import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Appicons{
  final List<Map<String,dynamic>> homeexpense=[
    {
      "name":"Internet",
      "icon":FontAwesomeIcons.wifi
    },
    {
      "name":"Electricity",
      "icon":FontAwesomeIcons.bolt
    },
    {
      "name":"Water",
      "icon":FontAwesomeIcons.water
    },
    {
      "name":"Rent",
      "icon":FontAwesomeIcons.house
    },
    {
      "name":"Travel",
      "icon":FontAwesomeIcons.car
    },
    {
      "name":"Transport",
      "icon":FontAwesomeIcons.bus
    },
    {
      "name":"Education",
      "icon":FontAwesomeIcons.graduationCap
    },
    {
      "name":"Food",
      "icon":FontAwesomeIcons.bowlFood
    },
    {
      "name":"Clothing",
      "icon":FontAwesomeIcons.shirt
    },
    {
      "name":"Health",
      "icon":FontAwesomeIcons.suitcaseMedical
    },
    {
      "name":"Grocery",
      "icon":FontAwesomeIcons.cartShopping
    },
    {
      'name':'Mobile Recharge',
      'icon':FontAwesomeIcons.mobile
    },
    {
      'name':'Salary',
      'icon':FontAwesomeIcons.rupeeSign
    },
    {
      "name":"others",
      "icon":FontAwesomeIcons.cartPlus
    },
  ];

  IconData getexpensecat(String Cname){
    final category=homeexpense.firstWhere((category) => category['name']==Cname,orElse: ()=>{"icon":FontAwesomeIcons.cartShopping});
    return category['icon'];
  }
}