import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../widget/recent_goal_card.dart';

class RecentGoalsPage extends StatelessWidget {
  const RecentGoalsPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Text('Recent Goals'),),
            Expanded(
              flex: 5,
              child: 
                      Consumer<FinanceProvider>(
                      builder: (context, provider, child) =>
                      FutureBuilder (
                      future: provider.goalLoaded,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (provider.goals.length < 3) ? provider.goals.length : 3,
                            itemBuilder: (_,int index) => RecentGoalCard(goalUsed: provider.goals.elementAt(index)),
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }
            ),
          )
        )//
      ],
    );
  }
}
