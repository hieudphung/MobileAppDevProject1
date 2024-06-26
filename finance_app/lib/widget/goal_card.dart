import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../database/finance_tables.dart';
import '../model/goal.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key,
    required this.goalId,
    required this.name,
    required this.goalType,
    required this.goalCurrent,
    required this.goalTarget,
  });

  final int goalId;
  final String name;
  final int goalType;
  final int goalCurrent;
  final int goalTarget;

  @override
  Widget build(BuildContext context) {
    double currentDouble = goalCurrent.toDouble();
    double targetDouble = goalTarget.toDouble();

    return Card (
      child: Column(
        children: <Widget>[
          GoalHead(cardTitle: name, currentAmount: goalCurrent, targetAmount: goalTarget),
          GoalBar(goalBar: currentDouble/targetDouble),
          GoalButtons(goalId: goalId),
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

class GoalButtons extends StatelessWidget {
  const GoalButtons({super.key,
    required this.goalId
  });

  final int goalId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
              child: OutlinedButton(
              onPressed: () => {print(goalId)}, 
              child: const Text('Details'),
        ),),
        Expanded(
              child: OutlinedButton(
              onPressed: () => {print(goalId)}, 
              child: const Text('Add to Goal'),
        ),),
      ],
    );
  }
}