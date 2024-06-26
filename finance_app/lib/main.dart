import 'package:flutter/material.dart';
//import '../pages/test_expense_page.dart';

import '../pages/homepage.dart';

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


