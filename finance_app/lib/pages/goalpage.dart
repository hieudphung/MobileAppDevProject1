import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../model/goal.dart';
import '../widget/goal_card.dart';

//Mostly to have as a null goal
const emptyGoal = Goal(id: 0, name: '', goalType: 0, description: '', goalCurrent: 0, goalTarget: 0);

//This is an internal variable for the alert form
Goal goalFromForm = emptyGoal;

class GoalsScreen extends StatelessWidget {
 const GoalsScreen({super.key});
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

  void keepGoalAddData(bool validated, String formName, int formGoalType, String formDescription, int targetFromForm) {
    if (validated) {
      goalFromForm = Goal(name: formName, goalType: formGoalType, description: formDescription, goalCurrent: 0, goalTarget: targetFromForm);
    } else {
      goalFromForm = emptyGoal;
    }
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: AddGoalForm(keepingData: keepGoalAddData),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                print(goalFromForm.toString());

                goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Handle adding new goal
                Navigator.of(context).pop();

                // Adding to provider
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
  const AddGoalForm({super.key,
  required this.keepingData});

  final Function keepingData;

  @override
  _AddGoalFormState createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final _formKey = GlobalKey<FormState>();
  bool validated = false;
  
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

            validator: (value) {
              if (value!.isEmpty) {
                validated = false;

                return 'Please enter a goal name';
              } else {
                validated = true;
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