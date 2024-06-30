import 'package:flutter/material.dart';
import 'dart:math';

class RandomTipsPage extends StatefulWidget {
  @override
  _RandomTipsPageState createState() => _RandomTipsPageState();
}

class _RandomTipsPageState extends State<RandomTipsPage> {
  final List<String> tips = [
    'Save a portion of your income each month.',
    'Create and stick to a budget.',
    'Invest in a diversified portfolio.',
    'Avoid high-interest debt.',
    'Track your expenses regularly.',
    'Plan for retirement early.',
    'Build an emergency fund.',
    'Live below your means.',
    'Take advantage of employer matching in retirement accounts.',
    'Educate yourself about personal finance.'
  ];

  String randomTip = '';

  @override
  void initState() {
    super.initState();
    generateRandomTip();
  }

  void generateRandomTip() {
    final random = Random();
    setState(() {
      randomTip = tips[random.nextInt(tips.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Random Tips"),
            Text(
              randomTip,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: generateRandomTip,
              child: Text('Show Another Tip'),
            ),
          ],
        ),
      );
  }
}