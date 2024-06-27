import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../widget/goal_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key,
    //required this.goalData,
  });

  //final List<Goal> goalData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Finance Goals'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddGoalDialog(context);
            },
          ),
        ),

        Flexible(
          child: 
                Consumer<FinanceProvider>(
                builder: (context, provider, child) =>
                ListView.builder(
            itemCount: provider.goals.length,
            itemBuilder: (_,int index) => GoalCard(goalUsed: provider.goals.elementAt(index)),
              ),
          )
        )//*/
      ],
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: AddGoalForm(),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Handle adding new goal
                Navigator.of(context).pop();

                var provider = context.read<FinanceProvider>();
                provider.addNewGoal();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddGoalForm extends StatefulWidget {
  @override
  _AddGoalFormState createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final _formKey = GlobalKey<FormState>();

  String _goalName = '';
  String _goalType = 'Saving';
  String _description = '';
  int goalAmount = 100;


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Goal Name'),
            /*
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a goal name';
              }
              return null;
            },
            */
            onSaved: (value) {
              _goalName = value!;
            },
          ),
          DropdownButtonFormField<String>(
            value: _goalType,
            items: <String>['Saving', 'Investment', 'Miscellaneous'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Goal Type'),
            onChanged: (value) {
              setState(() {
                _goalType = value!;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onSaved: (value) {
              _description = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Target Amount'),
            keyboardType: TextInputType.number,
            onSaved: (value) {
              int newAmount = int.parse(value!);

              goalAmount = newAmount;

              if (newAmount < 100) {
                goalAmount = 100;
              }

              if (newAmount > 10000) {
                goalAmount = 10000;
              }
            },
          ),
        ],
      ),
    );
  }
}