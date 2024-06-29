import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../widget/expense_card.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: 
              Consumer<FinanceProvider>(
                builder: (context, provider, child) =>
                FutureBuilder (
                future: Future.wait([provider.fetchExpenses(), provider.organizeMonths(), provider.expensesLoaded]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: provider.monthDatasets.length,
                          itemBuilder: (_,int index) => ExpenseCard(monthDataset: provider.monthDatasets.elementAt(index)),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                } 
             )  
          )
        )
      ],
    );
  }
}
