import 'package:flutter/material.dart';
//import '../pages/test_expense_page.dart';

 import 'package:fl_chart/fl_chart.dart';
import 'expense.dart';
import 'recent_transactions_page.dart';
import 'recent_goals_page.dart';
import 'random_tips_page.dart';
import '../pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FinanceApp());

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.blueGrey[300], // Change the background color here
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
        selectedFontSize: 18.0, // Adjust as needed
        unselectedFontSize: 16.0, // Adjust as needed
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Adjust as needed
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Adjust as needed
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
            color: Colors.blueGrey, // Example color for Recent Spending / Income
          ),
          SectionCard(
            title: 'Recent Goals',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentGoalsPage()),
              );
            },
            color: Colors.blueGrey, // Example color for Recent Goals
          ),
          SectionCard(
            title: 'Random Tips',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomTipsPage()),
              );
            },
            color: Colors.blueGrey, // Example color for Random Tips
          ),
        ],
      ),
    );
  }
}


