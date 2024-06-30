import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './finance_provider.dart';

import '../pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: const FinanceApp(),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey, // Adjust primarySwatch to match your design
        ),
        scaffoldBackgroundColor: Colors.blueGrey[800], // Scaffold background color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800], // App bar background color
          titleTextStyle: TextStyle(
            color: Colors.white, // App bar title text color
            fontWeight: FontWeight.bold, // App bar title text weight
            fontSize: 20.0, // App bar title text size
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey[800], // Bottom navigation bar background color
          selectedItemColor: Colors.amber[800], // Selected item color
          unselectedItemColor: Colors.white, // Unselected item color
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      home: HomePage(),
    );
  }
}
