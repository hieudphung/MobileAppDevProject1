import 'package:flutter/material.dart';

// import '../database/finance_tables.dart';
// import '../model/goal.dart';

import '../common/common.dart';

class GoalDetail extends StatelessWidget {
  const GoalDetail({super.key,
    required this.goalExpenseMonth,
    required this.goalCost,
    required this.expenseID});

  final int goalExpenseMonth;
  final int goalCost;
  final int expenseID;

  @override
  Widget build(BuildContext context) {
    String monthString = getMonth(goalExpenseMonth);

    return Row(children: <Widget>[
        Expanded(
          child: Text(monthString),
        ),
        Expanded(
          child: Text('\$ $goalCost'),
        ),
        SizedBox(
          child: IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.delete),
          ),
        ),
    ],);
  }
}