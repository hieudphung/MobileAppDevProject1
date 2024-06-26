import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense.dart';
import 'recent_transactions_page.dart';
import 'recent_goals_page.dart';
import 'random_tips_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Expense> _expenses = [];

  static List<Widget> _widgetOptions(BuildContext context, List<Expense> expenses) => <Widget>[
    HomeScreen(),
    GoalsScreen(),
    SpendingScreen(expenses: expenses),
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() async {
    // Load expenses from the database
    final expenses = await getExpenses(); // Implement this function to fetch expenses from the database
    setState(() {
      _expenses = expenses;
    });
  }

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
      body: _widgetOptions(context, _expenses).elementAt(_selectedIndex),
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
          SectionCard(
            title: 'Recent Spending / Income',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentTransactionsPage()),
              );
            },
          ),
          SectionCard(
            title: 'Recent Goals',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentGoalsPage()),
              );
            },
          ),
          SectionCard(
            title: 'Random Tips',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomTipsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  SectionCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
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
  final List<Expense> expenses;

  SpendingScreen({required this.expenses});

  @override
  _SpendingScreenState createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
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
              sections: widget.expenses
                  .map((e) => PieChartSectionData(
                value: e.cost.toDouble(),
                title: 'Type ${e.expenseType}: \$${e.cost}',
                color: _getColorByType(e.expenseType),
              ))
                  .toList(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showAddExpenseDialog(context);
          },
          child: Text('Add Expenditure'),
        ),
      ],
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Expenditure'),
          content: AddExpenseForm(onAdd: (expense) {
            setState(() {
              widget.expenses.add(expense);
            });
          }),
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

  Color _getColorByType(int type) {
    switch (type) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class AddExpenseForm extends StatefulWidget {
  final Function(Expense) onAdd;

  AddExpenseForm({required this.onAdd});

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _expenditureType = '1'; // Default to 1 (Groceries)
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
            items: <String>['1', '2', '3'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('Type $value'),
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
                final expense = Expense(
                  id: DateTime.now().millisecondsSinceEpoch,
                  isExpense: true,
                  cost: int.parse(_amount),
                  expenseType: int.parse(_expenditureType),
                  month: DateTime.now().month,
                );
                widget.onAdd(expense);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
