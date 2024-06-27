import 'package:flutter/material.dart';

import '../database/finance_tables.dart';

import '../model/goal.dart';
import '../widget/goal_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key,
    required this.goalData,
  });

  final List<Goal> goalData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Finance Goals'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddGoalDialog(context);
            },
          ),
        ),

        /*
        Expanded(
          child: ListView.builder(
            itemCount: goalData.length, // replace with your goals count
            itemBuilder: (context, index) {
              return GoalCard();
            },
          ),
        ),
        */

        Flexible(
          child: 
              ListView.builder(
          itemCount: goalData.length,
          itemBuilder: (_,int index) => GoalCard(goalUsed: goalData[index]),
            ),
        )
        //*/
      ],
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Goal'),
          content: AddGoalForm(),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Handle adding new goal
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/*
class GoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text('Goal Name'),
        subtitle: Text('Total Amount: \$1000'),
        trailing: TextButton(
          child: Text('Pay'),
          onPressed: () {
            // Handle pay towards goal
          },
        ),
      ),
    );
  }
}
*/

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
            decoration: InputDecoration(labelText: 'Goal Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a goal name';
              }
              return null;
            },
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
            decoration: InputDecoration(labelText: 'Goal Type'),
            onChanged: (value) {
              setState(() {
                _goalType = value!;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            onSaved: (value) {
              _description = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Target Amount'),
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