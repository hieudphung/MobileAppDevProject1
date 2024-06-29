import 'package:flutter/material.dart';

// import '../database/finance_tables.dart';
import '../model/goal.dart';

// This is a modified goal card file
// Exists as a modified iteration of goal card, but with minimal functionality, only display

class RecentGoalCard extends StatelessWidget {
  const RecentGoalCard({super.key,
    required this.goalUsed,
  });

  final Goal goalUsed;

  @override
  Widget build(BuildContext context) {
    double currentDouble = goalUsed.goalCurrent.toDouble();
    double targetDouble = goalUsed.goalTarget.toDouble();

    return Card (
      child: Column(
        children: <Widget>[
          GoalHead(cardTitle: goalUsed.name, currentAmount: goalUsed.goalCurrent, targetAmount: goalUsed.goalTarget),
          GoalBar(goalBar: currentDouble/targetDouble),
        ]
      )
    );
  }
}

class GoalHead extends StatelessWidget {
  const GoalHead({super.key,
    required this.cardTitle,
    required this.currentAmount,
    required this.targetAmount,
  });

  final String cardTitle;
  final int currentAmount;
  final int targetAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(cardTitle)),
        Expanded(child: Text('$currentAmount / $targetAmount')),
      ],
    );
  }
}

class GoalBar extends StatelessWidget {
  const GoalBar({super.key,
    required this.goalBar,
  });

  final double goalBar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: LinearProgressIndicator(
            backgroundColor: const Color.fromARGB(255, 8, 21, 29),
            value: goalBar,
            minHeight: 20.0,
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 154, 3)),
          ),
        ),
      ],
    );
  }
}
