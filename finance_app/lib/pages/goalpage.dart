import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../model/goal.dart';
import '../widget/goal_card.dart';

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
                FutureBuilder (
                future: provider.goalLoaded,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: provider.goals.length,
                      itemBuilder: (_,int index) => GoalCard(goalUsed: provider.goals.elementAt(index)),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }
                
                ),
          )
        )//*/
      ],
    );
  }

  void _showAddGoalDialog(BuildContext context) {
  Map data = {}; //This will hold my data.
    //And this function edits/adds data to the Map.
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //This is for processing the data into the database
    void makeGoal(bool validated, String goalName, int goalType, String description, int goalAmount) {
      if (validated) {
        Goal formGoal = Goal(id: 3, name: goalName, goalType: goalType, description: description, goalCurrent: 0, goalTarget: goalAmount);

        var provider = context.read<FinanceProvider>();
        provider.addNewGoal(formGoal);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: AddGoalForm(keepingData: saveData),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Adding to provider
                makeGoal(data['validated'], data['goalName'], data['goalType'], data['description'], data['goalAmount']);

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
  int _goalType = 1;
  String _typeInput = 'Saving';
  String _description = '';
  int goalAmount = 0;

  void validate() {
    if (_goalName.isEmpty || goalAmount == 0) {
      validated = false;
    } else {
      validated = true;
    }
  }

  void setGoalType() {
    if (_typeInput == 'Saving') {
      _goalType = 1;
    } else if (_typeInput == 'Investment') {
      _goalType = 2;
    } else if (_typeInput == 'Miscellaneous') {
      _goalType = 3;
    }
  }

  @override
  void initState() {
    super.initState();
  
    widget.keepingData('validated', validated);
    widget.keepingData('goalName', _goalName);
    widget.keepingData('goalType', _goalType);
    widget.keepingData('description', _description);
    widget.keepingData('goalAmount', goalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Goal Name'),

            onChanged: (value) {
              _goalName = value;

              validate();

              setState(() {
                widget.keepingData('validated', validated);
                widget.keepingData('goalName', _goalName);
                });
            },
          ),
          DropdownButtonFormField<String>(
            value: _typeInput,
            items: <String>['Saving', 'Investment', 'Miscellaneous'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Goal Type'),
            onChanged: (value) {
              setState(() {
                _typeInput = value!;
                setGoalType();

                setState(() {widget.keepingData('goalType', _goalType);});
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),

            onChanged: (value) {
              _description = value;
              setState(() {widget.keepingData('description', _description);});
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Target Amount'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int newAmount = int.parse(value);

              goalAmount = newAmount;

              if (newAmount < 100) {
                goalAmount = 100;
              }

              if (newAmount > 10000) {
                goalAmount = 10000;
              }

              validate();
              
              setState(() {
                widget.keepingData('validated', validated);
                widget.keepingData('goalAmount', goalAmount);
              });
            },
          ),
        ],
      ),
    );
  }
}