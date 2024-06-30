import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../finance_provider.dart';

import 'package:pie_chart/pie_chart.dart';

import '../model/expense.dart';
import '../model/month_data.dart';

import '../common/common.dart';

final gradientForExpenses = <List<Color>> [
  [
    const Color.fromRGBO(129, 182, 205, 1),
    const Color.fromRGBO(91, 253, 199, 1),
  ],
  [
    const Color.fromRGBO(198, 224, 68, 1),
    const Color.fromRGBO(129, 224, 112, 1),
  ],
  [
    const Color.fromRGBO(176, 63, 62, 1),
    const Color.fromRGBO(254, 154, 92, 1),
  ],
  [
    const Color.fromARGB(255, 219, 68, 224),
    const Color.fromARGB(255, 163, 111, 223),
  ],
];

final gradientForIncome = <List<Color>> [
  [
    const Color.fromARGB(255, 49, 128, 173),
    const Color.fromARGB(255, 83, 126, 245),
  ],
  [
    const Color.fromARGB(255, 219, 201, 95),
    const Color.fromARGB(255, 238, 192, 41),
  ],
];

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

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, 
    required this.monthDataset,
  });
  
  final MonthData monthDataset;

  @override
  Widget build(BuildContext context) {
    //Decide on a title first
    String cardTitle = getMonth(monthDataset.monthNumber);
    
    return Card (
      child: Column(
        children: <Widget>[
          ExpenseHead(cardTitle: cardTitle),
          ExpenseBody(
            monthNumber: monthDataset.monthNumber, 
            totalExpense: monthDataset.totalExpense, 
            expenseDataset: monthDataset.expenseDataset, 
            totalIncome: monthDataset.totalIncome, 
            incomeDataset: monthDataset.incomeDataset),
        ]
      )
    );
  }
}

class ExpenseHead extends StatelessWidget {
  const ExpenseHead({super.key, required this.cardTitle});

  final String cardTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox (
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(cardTitle),
      )
    );
  }
}

class ExpenseBody extends StatelessWidget {
  const ExpenseBody({super.key, 
    required this.monthNumber,
    required this.totalExpense,
    required this.expenseDataset,
    required this.totalIncome,
    required this.incomeDataset,
  });

  final int monthNumber;

  final int totalExpense;
  final Map<String, double> expenseDataset;
  final int totalIncome;
  final Map<String, double> incomeDataset;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: PieChart(
            dataMap: expenseDataset,
            chartType: ChartType.ring,
            baseChartColor: Colors.grey[300]!,
            gradientList: gradientForExpenses,
            centerText: 'Expense:\n\$ $totalExpense',
            legendOptions: const LegendOptions(
              showLegends: false
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
              showChartValuesOutside: false,
            ))),
          ),

          Expanded( 
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: PieChart(
            dataMap: incomeDataset,
            chartType: ChartType.ring,
            baseChartColor: Colors.grey[200]!,
            gradientList: gradientForIncome,
            centerText: 'Income:\n\$ $totalIncome',
            legendOptions: const LegendOptions(
              showLegends: false
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
              showChartValuesOutside: false,
            ))),
          ),

          Expanded( child: StatBar(monthNumber: monthNumber)),
        ]
      );
  }
}

class StatBar extends StatelessWidget {
  const StatBar ({super.key, 
    required this.monthNumber,
  });

  final int monthNumber;

  @override
  Widget build(BuildContext context) {
    return Column (
      children: <Widget>[
            SizedBox(
              child: OutlinedButton(
              onPressed: () => {_showExpenditureDetailDialog(context)}, 
              child: const Text('Details'),
        ),),
        SizedBox(
              child: OutlinedButton(
              onPressed: () => {_showAddExpenditureDialog(context)}, 
              child: const Text('Add To'),
        ),),
      ],);
  }
  
  void _showAddExpenditureDialog(BuildContext context) {
    // For getting form data from pop-up
    Map data = {}; 

    //For saving data
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For adding the expense from form
    void makeExpense(bool validated, int isExpenditure, int expenseType, int amountToPay) {
      if (validated) {
        var provider = context.read<FinanceProvider>();
        provider.addExpense(monthNumber, isExpenditure, expenseType, amountToPay);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Expenditure'),
          content: AddExpenditureForm(keepingData: saveData),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
            onPressed: () {
              makeExpense(data['validated'], data['isExpenditure'], data['expenditureType'], data['amount']);

              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
          ],
        );
      },
    );
  }



  void _showExpenditureDetailDialog(BuildContext context) {
    //get month first
    String monthText = getMonth(monthNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$monthText Expenditures'),
          content: AddExpenditureDetails(monthId: monthNumber),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
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
  final Function keepingData;

  AddExpenditureForm({required this.keepingData});

  @override
  _AddExpenditureFormState createState() => _AddExpenditureFormState();
}

class _AddExpenditureFormState extends State<AddExpenditureForm> {
  final _formKey = GlobalKey<FormState>();

  //0 is expense
  //1 is income
  int _selection = 1;

  String _expenditureType = 'Groceries';
  int expenditureTypeNum = 1;

  int _amount = 0;
  bool validated = false;

  void validate() {
    if (_amount < 1) {
      validated = false;
    } else {
      validated = true;
    }
  }

  void setExpenseType() {
    if (selectionIsExpense()) {
      if (_expenditureType == 'Groceries') {
        expenditureTypeNum = 1;
      } else if (_expenditureType == 'Insurance') {
        expenditureTypeNum = 2;
      } else if (_expenditureType == 'Bills') {
        expenditureTypeNum = 3;
      } 
    } else {
      if (_expenditureType == 'Income') {
        expenditureTypeNum = 1;
      } else if (_expenditureType == 'Extra Income') {
        expenditureTypeNum = 2;
      }
    }
  }

  bool selectionIsExpense() {
    return (_selection == 1);
  }

  @override
  void initState() {
    super.initState();

    widget.keepingData('validated', validated);
    widget.keepingData('isExpenditure', _selection);
    widget.keepingData('expenditureType', expenditureTypeNum);
    widget.keepingData('amount', _amount);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            ListTile(
            title: const Text('Expense'),
            leading: Radio<int>(
              value: 1,
              groupValue: _selection,
              onChanged: (value) {
                setState(() {
                  _selection = value!;

                  _expenditureType = 'Groceries';
                  expenditureTypeNum = 1;

                  widget.keepingData('isExpenditure', _selection);
                  widget.keepingData('expenditureType', expenditureTypeNum);
                });
              },
              ),
            ),
            ListTile(
            title: const Text('Income'),
            leading: Radio<int>(
              value: 2,
              groupValue: _selection,
              onChanged: (value) {
                setState(() {
                  _selection = value!;

                  _expenditureType = 'Income';
                  expenditureTypeNum = 1;

                  widget.keepingData('isExpenditure', _selection);
                  widget.keepingData('expenditureType', expenditureTypeNum);
                });
              },
              ),
            ),

          DropdownButtonFormField<String>(
            value: _expenditureType,
            items: (selectionIsExpense()) ? 
              <String>['Groceries', 'Insurance', 'Bills'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList() :
            <String>['Income', 'Extra Income'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList() 
            ,
            decoration: const InputDecoration(labelText: 'Expenditure Type'),
            onChanged: (value) {
              _expenditureType = value!;
              setExpenseType();

              setState(() {widget.keepingData('expenditureType', expenditureTypeNum);});
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an amount';
              }
              
              return null;
            },

            onChanged: (value) {
              int newAmount = int.parse(value);

              _amount = newAmount;

              if (newAmount < 0) {
                _amount = 0;
              }

              if (newAmount > 10000) {
                _amount = 10000;
              }

              validate();
              
              setState(() {
                widget.keepingData('validated', validated);
                widget.keepingData('amount', _amount);
              });
            },
          ),
        ],
      ),
    );
  }
}




class AddExpenditureDetails extends StatefulWidget {
  const AddExpenditureDetails({super.key,
  required this.monthId,
  });

  final int monthId;

  @override
  _AddExpenditureDetailsState createState() => _AddExpenditureDetailsState();
}

class _AddExpenditureDetailsState extends State<AddExpenditureDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Make a list from the returned month expenses
            const Flexible(child: Text('Expenses')),
            ExpenseDetailList(monthId: widget.monthId, isExpense: true),
            const Flexible(child: Text('Income')),
            ExpenseDetailList(monthId: widget.monthId, isExpense: false),
        ],
      ),
      
    );
  }
}

class ExpenseDetailList extends StatelessWidget {
  const ExpenseDetailList ({super.key,
    required this.monthId,
    required this.isExpense,
  });

  final int monthId;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return //Text('${expenseDetails.length}');
      Expanded(
        child: 
              Consumer<FinanceProvider>(
                builder: (context, provider, child) =>
                ListView.builder(
              shrinkWrap: true,
              itemCount: isExpense ? 
                          provider.getExpensesByMonth(monthId).length : 
                          provider.getIncomeByMonth(monthId).length,
              itemBuilder: (_,int index) => isExpense ? 
                                            ExpenseDetail(expenseToDetail: provider.getExpensesByMonth(monthId)[index]) :
                                            ExpenseDetail(expenseToDetail: provider.getIncomeByMonth(monthId)[index]),
            )
        )
    );
  }
}

class ExpenseDetail extends StatelessWidget {
  const ExpenseDetail ({super.key,
    required this.expenseToDetail,
  });

  final Expense expenseToDetail;

  void _deleteExpense(BuildContext context) {
    var provider = context.read<FinanceProvider>();

    //Get stuff to expand expenses and income
    provider.deleteExpense(expenseToDetail.id!);
  }

  @override
  Widget build(BuildContext context) {
    Color expenseColor = const Color.fromRGBO(0, 0, 0, 0);
    String expenseLabel = '';

    //1 is expense
    if (expenseToDetail.isExpense == 1) {
      switch(expenseToDetail.expenseType){
          case 1:
            expenseColor = gradientForExpenses[0][0];
            expenseLabel = 'Groceries';
          case 2:
            expenseColor = gradientForExpenses[1][0];
            expenseLabel = 'Insurance';
          case 3:
            expenseColor = gradientForExpenses[2][0];
            expenseLabel = 'Bills';
          case 4:
            expenseColor = gradientForExpenses[3][0];
            expenseLabel = 'Goal';
      }
    } else {
    //2 is income
      switch(expenseToDetail.expenseType){
          case 1:
            expenseColor = gradientForIncome[0][0];
            expenseLabel = 'Income';
          case 2:
            expenseColor = gradientForIncome[1][0];
            expenseLabel = 'Extra Income';
      }
    }

    return Flexible(
      child: Row(
        children: <Widget>[
          Expanded (
            child: Icon(
              Icons.circle,
              color: expenseColor,)
            ,
          ),
          Expanded (
            flex: 5,
            child: Text ('$expenseLabel -- Cost: \$${expenseToDetail.cost}'),
          ),
          Expanded (
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteExpense(context),
            )
          ),
        ]
      )
    );
  }
}