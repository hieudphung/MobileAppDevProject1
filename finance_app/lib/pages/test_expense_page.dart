import 'package:flutter/material.dart';
import '../database/expense_table.dart';
import '../model/expense.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.title});

  final String title;

  @override
  State<TestPage> createState() => _TestExpensePageState();
}

class _TestExpensePageState extends State<TestPage> {
  //int _counter = 0;
  List<Expense> expenses = List.empty();

  void addExpense() async {
    const newExpense = Expense (
      isExpense: 0,
      cost: 900,
      expenseType: 1,
      month: 6,
    );

    await ExpenseDatabase.instance.addExpense(newExpense);
  }

  void removeExpense(int index) async {
    await ExpenseDatabase.instance.deleteExpense(index);
  }

  void getExpenses() async {
    //expenses = await ExpenseDatabase.instance.expenses();
  
    expenses = await ExpenseDatabase.instance.filterExpenses(0, 6);
  }

  void removeExpenseButton(int index) {
    setState(() {
      removeExpense(index);
      getExpenses();
    });
  }

  void _incrementCounter() {
    //Add a premade expense
    setState(() {
      //_counter++;
      addExpense();
      getExpenses();
    });
  }

  @override
  void initState() {
    super.initState();

    getExpenses();
  }

  @override
  void dispose() {
    ExpenseDatabase.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            /*
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            */
            Flexible (
              child: 
                ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (_,int index) =>
          Card( 
            child: Row(
            children: <Widget> [
                Expanded(child: Text('${expenses[index].id} ${expenses[index].isExpense} ${expenses[index].cost} ${expenses[index].expenseType} ${expenses[index].month}')),
                Expanded(child: FloatingActionButton(
              onPressed: () =>removeExpenseButton(expenses[index].id!),
              child: const Icon(Icons.delete),
            ),)
              ]
            )
            ),
          ),
        ),
      FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),], // This trailing comma makes auto-formatting nicer for build methods.
    )));
  }
}
