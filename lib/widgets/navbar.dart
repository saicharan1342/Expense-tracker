import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key, required this.selectedIndex, required this.onDestinationSelected, required this.theme});
  final bool theme;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: widget.theme?NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all<TextStyle?>(
              TextStyle(color: Colors.white))):NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all<TextStyle?>(
              TextStyle(color: Colors.black))),
      child: NavigationBar(
        backgroundColor:widget.theme?Colors.grey.shade800:Colors.white ,
        selectedIndex: widget.selectedIndex,
        onDestinationSelected:widget.onDestinationSelected,
        indicatorColor: Colors.blue.shade900,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home,color: widget.theme?Colors.white:Colors.black,),
            selectedIcon: Icon(Icons.home,color: Colors.white,),
            label: 'Home',

          ),
          NavigationDestination(
            icon: Icon(Icons.currency_rupee,color: widget.theme?Colors.white:Colors.black),
            selectedIcon: Icon(Icons.currency_rupee,color: Colors.white,),
            label: 'Transaction',
          ),

        ],
      ),
    );
  }
}
