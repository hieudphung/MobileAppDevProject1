import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/common.dart';

import '../finance_provider.dart';

import '../model/goal.dart';
import '../model/expense.dart';

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
          GoalButtons(goalId: goalUsed.id!, goalName: goalUsed.name, goalType: goalUsed.goalType, description: goalUsed.description),
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
        Expanded(child: Text('\$$currentAmount / \$$targetAmount')),
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
    required this.goalId,
    required this.goalName,
    required this.goalType,
    required this.description
  });

  final int goalId;
  final String goalName;
  final int goalType;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        //This button is for adding payments to the goal
        Expanded(
              child: IconButton(
              onPressed: () => {_showPayGoalDialog(context)}, 
              icon: const Icon(Icons.add),
        ),),

        Expanded(
              child: IconButton(
              onPressed: () => {_showGoalInfoDialog(context)}, 
              icon: const Icon(Icons.info),
        ),),

        //This button is for deleting an expense
        Expanded(
              child: IconButton(
              onPressed: () => {_showDeleteGoal(context)}, 
              icon: const Icon(Icons.delete),
        ),),
      ],
    );
  }

  void _showPayGoalDialog(BuildContext context) {
    // For getting form data from pop-up
    Map data = {}; 

    //For saving data
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //This is for processing the data into the database
    void payGoal(bool validated, int month, int amountToPay) {
      if (validated) {
        var provider = context.read<FinanceProvider>();
        provider.payForGoal(goalId, month, amountToPay);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: PayGoalForm(keepingData: saveData),
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

  void _showGoalInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Goal Details'),
          content: ShowGoalInfoDialog(goalId: goalId, goalName: goalName, goalType: goalType, description: description),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
          ],
        );
      },
    );
  }

  //Goal deletion form
  void _showDeleteGoal(BuildContext context) {
    //This is for processing the data into the database
    void deleteGoal() {
      var provider = context.read<FinanceProvider>();
      provider.deleteGoal(goalId);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Goal'),
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

}

//Goal payment form
class PayGoalForm extends StatefulWidget {
  const PayGoalForm({super.key,
  required this.keepingData});

  final Function keepingData;

  @override
  _PayGoalFormState createState() => _PayGoalFormState();
}

class _PayGoalFormState extends State<PayGoalForm> {
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
              _monthName = value!;
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
         Text("Are you sure you want to delete this goal?"),
        ],
    );
  }
}


class ShowGoalInfoDialog extends StatefulWidget {
  const ShowGoalInfoDialog({super.key,
    required this.goalId,
    required this.goalName,
    required this.goalType,
    required this.description,
  });

  final int goalId;
  final String goalName;
  final int goalType;
  final String description;

  @override
  _AddGoalDetailState createState() => _AddGoalDetailState();
}

class _AddGoalDetailState extends State<ShowGoalInfoDialog> {
  Color goalTypeColor = const Color.fromRGBO(0, 0, 0, 0);
  String goalTypeLabel = '';

  @override
  initState() {
    super.initState();

    switch(widget.goalType){
          case 1:
            goalTypeColor = Colors.blue;
            goalTypeLabel = 'Saving';
          case 2:
            goalTypeColor = Colors.green;
            goalTypeLabel = 'Investment';
          case 3:
            goalTypeColor = Colors.red;
            goalTypeLabel = 'Miscellaneous';
      }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Make a list from the returned month expenses
           Flexible(child: Text('Goal Name: ${widget.goalName}')),

           Flexible(child: 
            Row(children: <Widget>[
              Expanded (
            child: Icon(
              Icons.circle,
              color: goalTypeColor,),
            ),
            Expanded (
              flex: 5,
              child: Text ('Goal Type: $goalTypeLabel'),
            ),
            ],)),

           Flexible(child: Text('Description: ${widget.description}')),
            GoalDetailList(goalId: widget.goalId),
        ],
      ),
      
    );
  }
}

class GoalDetailList extends StatelessWidget {
  const GoalDetailList ({super.key,
    required this.goalId,
  });

  final int goalId;

  @override
  Widget build(BuildContext context) {
    return //Text('${expenseDetails.length}');
      Expanded(
        child: 
            //Static details

            //All the goal spending details here
              Consumer<FinanceProvider>(
                builder: (context, provider, child) =>
                ListView.builder(
              shrinkWrap: true,
              itemCount: provider.getExpensesByGoal(goalId).length,
              itemBuilder: (_,int index) => ExpenseGoalDetail(expenseGoalToDetail: provider.getExpensesByGoal(goalId)[index]),
            )
        )
    );
  }
}


class ExpenseGoalDetail extends StatelessWidget {
  const ExpenseGoalDetail ({super.key,
    required this.expenseGoalToDetail,
  });

  final Expense expenseGoalToDetail;

  void _deleteExpense(BuildContext context) {
    var provider = context.read<FinanceProvider>();

    //Get stuff to expand expenses and income
    provider.deleteExpense(expenseGoalToDetail.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: <Widget>[
          Expanded (
            flex: 5,
            child: Text ('${getMonth(expenseGoalToDetail.month)} - Cost: \$${expenseGoalToDetail.cost}'),
          ),
          Expanded (
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteExpense(context),
            )
          ),
        ]
      )
    );
  }
}