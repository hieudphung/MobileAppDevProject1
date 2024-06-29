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
    )
  );
}

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
        home: HomePage(),
      );
  }
}

