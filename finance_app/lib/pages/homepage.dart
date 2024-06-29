import 'package:flutter/material.dart';

import '../pages/goalpage.dart';
import '../pages/spendpage.dart';

import './random_tips_page.dart';
import './recent_goals_page.dart';
import './recent_transactions_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  //Stuff from database in Finance Provider

  /*
  void getExpenses() {
    var provider = context.read<FinanceProvider>();
    provider.addBaseExpenses();
  }
  */

  List<Widget> _widgetOptions(BuildContext context) => <Widget>[
    const HomeScreen(),
    const GoalsScreen(),
    const SpendingScreen(),
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
        title: const Text('Finance Tracker'),
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Adjust as needed
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal), // Adjust as needed
      ),

    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          /*
          SectionCard(
            title: 'Recent Spending / Income',
            onTap: () {
              Navigator.push(W
                context,
                MaterialPageRoute(builder: (context) => RecentTransactionsPage()),
              );
            },
            color: Colors.blueGrey, // Example color for Recent Spending / Income
          ),
          */
          const Expanded( 
            flex: 3,
            child: Card(
              color: Colors.blueGrey,
              child: RecentTransactionsPage(), // Example color for Recent Goals
            )
          ),

          const Expanded( 
            flex: 2,
            child: Card(
              color: Colors.blueGrey,
              child: RecentGoalsPage(), // Example color for Recent Goals
            )
          ),

          const Expanded( 
            flex: 2,
            child: Card(
              color: Colors.blueGrey,
              child: RandomTipsPage(), // Example color for Recent Goals
            )
          ),

          /*
          SectionCard(
            title: 'Random Tips',
            
            color: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomTipsPage()),
              );
            }, // Example color for Random Tips
          ),
          */
        ],
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
      margin: const EdgeInsets.all(11.0), // Increased margin for larger bubble appearance
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(55.0),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold), // White text style
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}