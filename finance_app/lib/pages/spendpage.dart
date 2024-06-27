import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingScreen extends StatefulWidget {
  @override
  _SpendingScreenState createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  List<Expenditure> _expenditures = [];

  void _addExpenditure(Expenditure expenditure) {
    setState(() {
      _expenditures.add(expenditure);
      _expenditures.sort((a, b) => b.amount.compareTo(a.amount));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spending Analysis'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddExpenditureDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Spending by Month',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChart(
                    PieChartData(
                      sections: _expenditures.map((e) {
                        return PieChartSectionData(
                          value: e.amount,
                          title: '${e.type}: \$${e.amount.toStringAsFixed(2)}',
                          color: e.color,
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(
                        show: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _expenditures.map((e) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e.color,
                    ),
                    title: Text(e.type),
                    trailing: Text('\$${e.amount.toStringAsFixed(2)}'),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showAddExpenditureDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Add Expenditure'),
            ),
          ],
        ),
      ),
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
  String _expenditureType = '';
  String _amount = '';
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Expenditure Type'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an expenditure type';
                }
                return null;
              },
              onSaved: (value) {
                _expenditureType = value!;
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Text('Pick a Color:'),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      Color? pickedColor = await showDialog(
                        context: context,
                        builder: (context) {
                          Color tempColor = _selectedColor;
                          return AlertDialog(
                            title: Text('Pick a color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: tempColor,
                                onColorChanged: (color) {
                                  tempColor = color;
                                },
                                showLabel: true,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Select'),
                                onPressed: () {
                                  Navigator.of(context).pop(tempColor);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      if (pickedColor != null) {
                        setState(() {
                          _selectedColor = pickedColor;
                        });
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final expenditure = Expenditure(
                    type: _expenditureType,
                    amount: double.parse(_amount),
                    color: _selectedColor,
                  );
                  widget.onAdd(expenditure);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
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
