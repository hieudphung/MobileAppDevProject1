import 'package:finance_app/widget/recent_expense_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../widget/recent_expense_card.dart';

class RecentTransactionsPage extends StatelessWidget {
  const RecentTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: Text('Recent Transactions'),),
            Expanded(
              flex: 4,
              child: 
                  Consumer<FinanceProvider>(
                  builder: (context, provider, child) =>
                  FutureBuilder (
                  future: Future.wait([provider.fetchExpenses(), provider.organizeMonths(), provider.expensesLoaded]),
                  builder: (context, snapshot) {
                  if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (provider.monthDatasets.isEmpty) ? 0 : 1,
                          itemBuilder: (_,int index) => RecentExpenseCard(monthDataset: provider.monthDatasets.elementAt(index)),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                } 
             )  
          )
        )//
      ],
    );
  }
}
