import 'package:flutter/material.dart';

class RandomTipsPage extends StatelessWidget {
  const RandomTipsPage ({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Tips'),
      ),
      body: Center(
        child: Text('Random Tips Page Content'),
      ),
    );
  }
}
