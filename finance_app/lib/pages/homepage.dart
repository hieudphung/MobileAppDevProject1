import 'package:flutter/material.dart';

import '../pages/goalpage.dart';
import '../pages/spendpage.dart';

import './random_tips_page.dart';
import './recent_goals_page.dart';
import './recent_transactions_page.dart';

import '../widget/section_card.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions(BuildContext context) => <Widget>[
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

class SectionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  SectionCard({required this.title, required this.onTap, required this.color});

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