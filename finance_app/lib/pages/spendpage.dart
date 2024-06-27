import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import '../widget/expense_card.dart';

import '../model/month_data.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key, 
    //required this.monthDatasets
  });

  //final List<MonthData> monthDatasets;

  void _addExpenditure(Expenditure expenditure) {
    //setState(() {
    //  _expenditures.add(expenditure);
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _showAddExpenditureDialog(context);
          },
          child: Text('Add Expenditure'),
        ),
        Flexible(
          child: 
              Consumer<FinanceProvider>(
                builder: (context, provider, child) =>
                ListView.builder(
          itemCount: provider.monthDatasets.length,
          itemBuilder: (_,int index) => ExpenseCard(monthDataset: provider.monthDatasets.elementAt(index)),
            ),
          )
        )
      ],
    );
  }

  void _showAddExpenditureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Expenditure'),
          content: AddExpenditureForm(onAdd: _addExpenditure),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddExpenditureForm extends StatefulWidget {
  final Function(Expenditure) onAdd;

  AddExpenditureForm({required this.onAdd});

  @override
  _AddExpenditureFormState createState() => _AddExpenditureFormState();
}

class _AddExpenditureFormState extends State<AddExpenditureForm> {
  final _formKey = GlobalKey<FormState>();
  String _expenditureType = 'Groceries';
  String _amount = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: _expenditureType,
            items: <String>['Groceries', 'Insurance', 'Bills'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Expenditure Type'),
            onChanged: (value) {
              setState(() {
                _expenditureType = value!;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an amount';
              }
              return null;
            },
            onSaved: (value) {
              _amount = value!;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final expenditure = Expenditure(
                  type: _expenditureType,
                  amount: double.parse(_amount),
                  color: _getColorByType(_expenditureType),
                );
                widget.onAdd(expenditure);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Color _getColorByType(String type) {
    switch (type) {
      case 'Groceries':
        return Colors.blue;
      case 'Insurance':
        return Colors.green;
      case 'Bills':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Expenditure {
  final String type;
  final double amount;
  final Color color;

  Expenditure({
    required this.type,
    required this.amount,
    required this.color,
  });
}
