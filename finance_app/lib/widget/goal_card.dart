import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

// import '../database/finance_tables.dart';
import '../model/goal.dart';

//This is the main card for goal

class GoalCard extends StatelessWidget {
  const GoalCard({super.key,
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
          GoalButtons(goalId: goalUsed.id!),
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
        //This button is for adding payments to the goal
        Expanded(
              child: IconButton(
              onPressed: () => {_showPayGoalDialog(context, goalId)}, 
              icon: const Icon(Icons.add),
        ),),

        //This button is for deleting an expense
        Expanded(
              child: IconButton(
              onPressed: () => {_showDeleteGoal(context, goalId)}, 
              icon: const Icon(Icons.delete),
        ),),
      ],
    );
  }

  void _showPayGoalDialog(BuildContext context, int goalId) {
    // For getting form data from pop-up
    Map data = {}; 

    //For saving data
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //This is for processing the data into the database
    void payGoal(bool validated, int month, int amountToPay) {
      if (validated) {
          //Goal formGoal = Goal(id: 3, name: goalName, goalType: goalType, description: description, goalCurrent: 0, goalTarget: goalAmount);
        
        var provider = context.read<FinanceProvider>();
        provider.payForGoal(goalId, month, amountToPay);
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
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                payGoal(data['validated'], data['month'], data['goalPay']);

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

//Goal payment form
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
  
  String _monthName = 'January';
  int month = 1;
  
  int goalPay = 0;

  void validate() {
    if (goalPay < 1) {
      validated = false;
    } else {
      validated = true;
    }
  }

  void setMonthType() {
    if (_monthName == 'January') {
      month = 1;
    } else if (_monthName == 'February') {
      month = 2;
    } else if (_monthName == 'March') {
      month = 3;
    } else if (_monthName == 'April') {
      month = 4;
    } else if (_monthName == 'May') {
      month = 5;
    } else if (_monthName == 'June') {
      month = 6;
    }
  }

  @override
  void initState() {
    super.initState();
  
    widget.keepingData('validated', validated);
    widget.keepingData('month', month);
    widget.keepingData('goalPay', goalPay);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          DropdownButtonFormField<String>(
            value: _monthName,
            items: <String>['January', 'February', 'March', 'April', 'May', 'June'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Month'),
            onChanged: (value) {
              setMonthType();

              setState(() {widget.keepingData('month', month);});
            },
          ),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Target Amount'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int newAmount = int.parse(value);

              goalPay = newAmount;

              if (newAmount < 0) {
                goalPay = 0;
              }

              if (newAmount > 10000) {
                goalPay = 10000;
              }

              validate();
              
              setState(() {
                widget.keepingData('validated', validated);
                widget.keepingData('goalPay', goalPay);
              });
            },
          ),
        ],
      ),
    );
  }
}

//Goal deletion form
void _showDeleteGoal(BuildContext context, int goalId) {
    //This is for processing the data into the database
    void deleteGoal() {
      var provider = context.read<FinanceProvider>();
      provider.deleteGoal(goalId);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: DeleteGoalForm(),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteGoal();

                // Handle adding new goal
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}

class DeleteGoalForm extends StatefulWidget {
  const DeleteGoalForm({super.key});

  @override
  _DeleteGoalFormState createState() => _DeleteGoalFormState();
}

class _DeleteGoalFormState extends State<DeleteGoalForm> {
  @override
  Widget build(BuildContext context) {
    return const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text("Are you sure you want to delete this goal?"),
        ],
    );
  }
}