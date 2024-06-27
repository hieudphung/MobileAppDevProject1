import 'package:flutter/material.dart';
import '../database/finance_tables.dart';
import '../model/goal.dart';

class GoalCard extends StatelessWidget {
  final int goalId;
  final String name;
  final int goalType;
  final int goalCurrent;
  final int goalTarget;

  const GoalCard({
    required this.goalId,
    required this.name,
    required this.goalType,
    required this.goalCurrent,
    required this.goalTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  '\$${goalCurrent.toString()}/\$${goalTarget.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Handle arrow button action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Handle delete button action
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: goalCurrent / goalTarget,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({
    super.key,
    required this.goalData,
  });

  final List<Goal> goalData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddGoalDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: goalData.length,
              itemBuilder: (_, int index) => GoalCard(
                goalId: goalData[index].id!,
                name: goalData[index].name,
                goalType: goalData[index].goalType,
                goalCurrent: goalData[index].goalCurrent,
                goalTarget: goalData[index].goalTarget,
              ),
            ),
          ),
        ],
      ),
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
            ElevatedButton(
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _goalType,
                items: <String>['Saving', 'Investment', 'Miscellaneous']
                    .map((String value) {
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
            ),
          ],
        ),
      ),
    );
  }
}
