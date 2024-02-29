import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineMonth extends StatefulWidget {
  const TimeLineMonth({super.key, required this.onChanged, required this.theme});
  final ValueChanged<String?> onChanged;
  final bool theme;
  @override
  State<TimeLineMonth> createState() => _TimeLineMonthState();
}

class _TimeLineMonthState extends State<TimeLineMonth> {
  String currentMonth = "";
  List<String> months=[];
  final scrollcon=ScrollController();

  void initState(){
    super.initState();
    DateTime now =DateTime.now();
    for(int i=-13;i<=0;i++){
      months.add(DateFormat('MMM y').format(DateTime(now.year,now.month+i,1)));
    }
    currentMonth = DateFormat('MMM y').format(now);
    Future.delayed(Duration(seconds: 1),(){
      scrolltoselected();
    });
  }
  scrolltoselected(){
    final selectedmonind=months.indexOf(currentMonth);
    if(selectedmonind!=-1){
      final scrolloff=(selectedmonind*100.0)-170;
      scrollcon.animateTo(scrolloff, duration: Duration(microseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        controller: scrollcon,
        itemCount: months.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            setState(() {
              widget.onChanged(months[index]);
              currentMonth=months[index];
            });
            scrolltoselected();
          },
          child: Container(
            width: 80,
            margin: EdgeInsets.all(9),
            decoration: BoxDecoration(
              color:currentMonth==months[index]?Colors.blue.shade900: widget.theme?Colors.purple.withOpacity(0.5):Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(child: Text(months[index],style: TextStyle(color:currentMonth==months[index]?Colors.white: widget.theme?Colors.white:Colors.purple ),)),
          ),
        );
      }),
    );
  }
}
