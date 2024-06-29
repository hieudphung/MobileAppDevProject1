import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';

import '../model/month_data.dart';

import '../common/common.dart';

final gradientForExpenses = <List<Color>> [
  [
    const Color.fromRGBO(129, 182, 205, 1),
    const Color.fromRGBO(91, 253, 199, 1),
  ],
  [
    const Color.fromRGBO(198, 224, 68, 1),
    const Color.fromRGBO(129, 224, 112, 1),
  ],
  [
    const Color.fromRGBO(176, 63, 62, 1),
    const Color.fromRGBO(254, 154, 92, 1),
  ],
  [
    const Color.fromARGB(255, 219, 68, 224),
    const Color.fromARGB(255, 163, 111, 223),
  ],
];

final gradientForIncome = <List<Color>> [
  [
    const Color.fromARGB(255, 49, 128, 173),
    const Color.fromARGB(255, 83, 126, 245),
  ],
  [
    const Color.fromARGB(255, 219, 201, 95),
    const Color.fromARGB(255, 238, 192, 41),
  ],
];

Color _getColorByType(String type) {
  switch (type) {
    case 'Groceries':
      return Colors.blue;
    case 'Insurance':
      return Colors.green;
    case 'Bills':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class RecentExpenseCard extends StatelessWidget {
  const RecentExpenseCard({super.key, 
    required this.monthDataset,
  });
  
  final MonthData monthDataset;

  @override
  Widget build(BuildContext context) {
    //Decide on a title first
    String cardTitle = getMonth(monthDataset.monthNumber);
    
    return Card (
      child: Column(
        children: <Widget>[
          RecentExpenseHead(cardTitle: cardTitle),
          RecentExpenseBody(
            monthNumber: monthDataset.monthNumber, 
            totalExpense: monthDataset.totalExpense, 
            expenseDataset: monthDataset.expenseDataset, 
            totalIncome: monthDataset.totalIncome, 
            incomeDataset: monthDataset.incomeDataset),
        ]
      )
    );
  }
}

class RecentExpenseHead extends StatelessWidget {
  const RecentExpenseHead({super.key, required this.cardTitle});

  final String cardTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox (
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(cardTitle),
      )
    );
  }
}

class RecentExpenseBody extends StatelessWidget {
  const RecentExpenseBody({super.key, 
    required this.monthNumber,
    required this.totalExpense,
    required this.expenseDataset,
    required this.totalIncome,
    required this.incomeDataset,
  });

  final int monthNumber;

  final int totalExpense;
  final Map<String, double> expenseDataset;
  final int totalIncome;
  final Map<String, double> incomeDataset;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: PieChart(
            dataMap: expenseDataset,
            chartType: ChartType.ring,
            baseChartColor: Colors.grey[300]!,
            gradientList: gradientForExpenses,
            centerText: 'Expense:\n\$ $totalExpense',
            legendOptions: const LegendOptions(
              showLegends: false
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
              showChartValuesOutside: false,
            ))),
          ),

          Expanded( 
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: PieChart(
            dataMap: incomeDataset,
            chartType: ChartType.ring,
            baseChartColor: Colors.grey[200]!,
            gradientList: gradientForIncome,
            centerText: 'Income:\n\$ $totalIncome',
            legendOptions: const LegendOptions(
              showLegends: false
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
              showChartValuesOutside: false,
            ))),
          ),

        ]
      );
  }
}
