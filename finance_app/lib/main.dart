import 'package:flutter/material.dart';
//import '../pages/test_expense_page.dart';

import 'package:fl_chart/fl_chart.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const TestPage(title: 'Flutter Demo Home Page'),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GoalsScreen(),
    SpendingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Spending',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SectionCard(title: 'Recent Spending / Income'),
          SectionCard(title: 'Recent Goals'),
          SectionCard(title: 'Random Tips'),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;

  SectionCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}

class GoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Finance Goals'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddGoalDialog(context);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // replace with your goals count
            itemBuilder: (context, index) {
              return GoalCard();
            },
          ),
        ),
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

class AddGoalForm extends StatefulWidget {
  @override
  _AddGoalFormState createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final _formKey = GlobalKey<FormState>();
  String _goalName = '';
  String _goalType = 'Saving';
  String _description = '';

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
        ],
      ),
    );
  }
}

class SpendingScreen extends StatefulWidget {
  @override
  _SpendingScreenState createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  List<Expenditure> _expenditures = [];

  void _addExpenditure(Expenditure expenditure) {
    setState(() {
      _expenditures.add(expenditure);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Spending by Month'),
        ),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _expenditures
                  .map((e) => PieChartSectionData(
                value: e.amount,
                title: '${e.type}: \$${e.amount.toStringAsFixed(2)}',
                color: e.color,
              ))
                  .toList(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showAddExpenditureDialog(context);
          },
          child: Text('Add Expenditure'),
        ),
      ],
    );
  }

  void _showAddExpenditureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Expenditure'),
          content: AddExpenditureForm(onAdd: _addExpenditure),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddExpenditureForm extends StatefulWidget {
  final Function(Expenditure) onAdd;

  AddExpenditureForm({required this.onAdd});

  @override
  _AddExpenditureFormState createState() => _AddExpenditureFormState();
}

class _AddExpenditureFormState extends State<AddExpenditureForm> {
  final _formKey = GlobalKey<FormState>();
  String _expenditureType = 'Groceries';
  String _amount = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: _expenditureType,
            items: <String>['Groceries', 'Insurance', 'Bills'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Expenditure Type'),
            onChanged: (value) {
              setState(() {
                _expenditureType = value!;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an amount';
              }
              return null;
            },
            onSaved: (value) {
              _amount = value!;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final expenditure = Expenditure(
                  type: _expenditureType,
                  amount: double.parse(_amount),
                  color: _getColorByType(_expenditureType),
                );
                widget.onAdd(expenditure);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Color _getColorByType(String type) {
    switch (type) {
      case 'Groceries':
        return Colors.blue;
      case 'Insurance':
        return Colors.green;
      case 'Bills':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Expenditure {
  final String type;
  final double amount;
  final Color color;

  Expenditure({
    required this.type,
    required this.amount,
    required this.color,
  });
}
