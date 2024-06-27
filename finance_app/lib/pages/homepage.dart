import 'package:flutter/material.dart';

import '../database/finance_tables.dart';

import '../pages/goalpage.dart';
import '../pages/spendpage.dart';

import './random_tips_page.dart';
import './recent_goals_page.dart';
import './recent_transactions_page.dart';

import '../model/expense.dart';
import '../model/goal.dart';
import '../model/month_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  //For getting stuff from the database
  List<Expense> expenses = List.empty(growable: true);
  List<MonthData> monthDatasets = List.empty(growable: true);
  List<Goal> goals = List.empty(growable: true);

  //Here is just getting a bunch of stuff from the database for later

  /*
  void getExpenses() async {
    expenses = await FinanceDatabase.instance.expenses();
  
    //expenses = await FinanceDatabase.instance.filterExpenses(0, 6);
  }
  */

  void getExpenses() {
    monthDatasets.add(
      const MonthData(
        monthNumber: 6,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 5,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 4,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 3,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 2,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 1,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );
  }

  /*
  void getGoals() async {
    goals = await FinanceDatabase.instance.goals();
  }
  */

  //placeholder data for goals
  
  void getGoals() {
    goals.add(const Goal(id: 0, name: 'Test Goal One', goalType: 1, description: 'Test Goal One', goalCurrent: 0, goalTarget: 600));
    goals.add(const Goal(id: 1, name: 'Test Goal Two', goalType: 1, description: 'Test Goal Two', goalCurrent: 520, goalTarget: 800));
    goals.add(const Goal(id: 2, name: 'Test Goal Three', goalType: 1, description: 'Test Goal Three', goalCurrent: 150, goalTarget: 500));
  }

  @override
  void initState() {
    super.initState();

    getExpenses();
    getGoals();
  }

  @override
  void dispose() {
    FinanceDatabase.instance.close();

    super.dispose();
  }

  List<Widget> _widgetOptions(BuildContext context) => <Widget>[
    HomeScreen(),
    GoalsScreen(goalData: goals),
    SpendingScreen(monthDatasets: monthDatasets),
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
      body: _widgetOptions(context).elementAt(_selectedIndex),
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
  const HomeScreen({super.key});

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

// Would put in separate file, but only really needed to separate home page content
class SectionCard extends StatelessWidget {
  const SectionCard({super.key,
    required this.title, 
    required this.onTap, 
    required this.color});

  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(11.0), // Increased margin for larger bubble appearance
      color: color,
      child: Padding(
        padding: EdgeInsets.all(55.0),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold), // White text style
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}