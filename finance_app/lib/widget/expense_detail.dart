import 'package:flutter/material.dart';

// import '../database/finance_tables.dart';
// import '../model/goal.dart';

import '../common/common.dart';

class ExpenseDetail extends StatelessWidget {
  const ExpenseDetail({super.key,
    required this.spendType,
    required this.spendCost,
    required this.expenseID});

  final int spendType;
  final int spendCost;
  final int expenseID;

  @override
  Widget build(BuildContext context) {
    String spendString = getSpendType(spendType);
    Icon spendIcon = getSpendIcon(spendType);

    return Row(children: <Widget>[
        SizedBox(
          child: spendIcon,
        ),
        Expanded(
          child: Text('$spendString - '),
        ),
        Expanded(
          child: Text('\$ $spendCost'),
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