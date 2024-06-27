import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;

  SectionCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}