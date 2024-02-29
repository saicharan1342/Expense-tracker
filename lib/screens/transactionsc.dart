import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/category_list.dart';
import '../widgets/tab_bar_view.dart';
import '../widgets/time_line_month.dart';

class Transactionsc extends StatefulWidget {
  const Transactionsc({Key? key, required this.theme}) : super(key: key);
  final bool theme;
  @override
  State<Transactionsc> createState() => _TransactionscState();
}

class _TransactionscState extends State<Transactionsc> {
  String? cate;
  String selectedMonth = DateFormat('MMM y').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme ? Colors.grey.shade800 : Colors.white,
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedMonth = value;
                });
              }
            },
            theme: widget.theme,
          ),
          CategoryList(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  cate = value;
                });
              }
            },
            theme: widget.theme,
          ),
          Tabbarview(
            cate: cate ?? 'All',
            monyear: selectedMonth,
            theme: widget.theme,
          ),
        ],
      ),
    );
  }
}
