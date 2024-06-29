import 'package:flutter/material.dart';
import '../database/finance_tables.dart';
import '../model/expense.dart';
import '../model/goal.dart';

//import '../widget/expense_card.dart';
import '../widget/goal_card.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.title});

  final String title;

  @override
  State<TestPage> createState() => _TestExpensePageState();
}

class _TestExpensePageState extends State<TestPage> {
  //int _counter = 0;
  List<Expense> expenses = List.empty();
  List<Goal> goals = List.empty();

  void addExpense() async {
    const newExpense = Expense (
      isExpense: 1,
      cost: 900,
      expenseType: 1,
      linkedGoal: 0,    // doesn't need a value, unless added from the pay goal button
      month: 6,
    );

    await FinanceDatabase.instance.addExpense(newExpense);
  }

  void removeExpense(int index) async {
    await FinanceDatabase.instance.deleteExpense(index);
  }

  void getExpenses() async {
    expenses = await FinanceDatabase.instance.expenses();
  
    //expenses = await FinanceDatabase.instance.filterExpenses(0, 6);
  }

  void addGoal() async {
    Goal newGoal = Goal (
      name: "Test Goal 2",
      goalType: 2,
      description: "This is another test goal!",
      goalCurrent: 0,
      goalTarget: 600,
    );

    await FinanceDatabase.instance.addGoal(newGoal);
  }

  void updateTargetGoal(Goal updatedGoal) async {
    await FinanceDatabase.instance.updateGoal(updatedGoal);
  }

  void removeGoal(int index) async {
    await FinanceDatabase.instance.deleteGoal(index);
  }

  void getGoals() async {
    goals = await FinanceDatabase.instance.goals();
  }

  void removeExpenseButton(int index) {
    setState(() {
      removeExpense(index);
      getExpenses();
    });
  }

  void removeGoalButton(int index) {
    setState(() {
      removeGoal(index);
      getGoals();
    });
  }

  void updateGoalButton(int index, String name, int goalType, String description, int currentGoal, int goalTarget) {
    int newCurrent = currentGoal + 100;

    Goal newGoal = Goal(id: index, name: name, goalType: goalType, description: description, goalCurrent: newCurrent, goalTarget: goalTarget);

    setState(() {
      updateTargetGoal(newGoal);
      getGoals();
    });
  }

  void _addExpenseCounter() {
    //Add a premade expense
    setState(() {
      //_counter++;
      addExpense();
      getExpenses();
    });
  }

  void _addGoalCounter() {
    //Add a premade goal
    setState(() {
      //_counter++;
      addGoal();
      getGoals();
    });
  }

  @override
  void initState() {
    super.initState();

    getExpenses();
    getGoals();
  }

  @override
  void dispose() {
    FinanceDatabase.instance.close();

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
            //const ExpenseCard(monthNumber: 6),
            //const GoalCard(),
            /*
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            */
            Flexible (
              child: 
              ListView.builder(
          itemCount: goals.length,
          itemBuilder: (_,int index) => GoalCard(goalUsed: goals[index]),
            ),),
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
              onPressed: () => removeExpenseButton(expenses[index].id!),
              child: const Icon(Icons.delete),
            ),)
              ]
            )
            ),
          ),
        ),
        Flexible (
              child: 
                ListView.builder(
          itemCount: goals.length,
          itemBuilder: (_,int index) =>
          Card( 
            child: Row(
            children: <Widget> [
                Expanded(child: Text('${goals[index].id} ${goals[index].name} ${goals[index].goalType} ${goals[index].description} ${goals[index].goalCurrent} ${goals[index].goalTarget}')),
                Expanded(child: FloatingActionButton(
              onPressed: () => removeGoalButton(goals[index].id!),
              child: const Icon(Icons.delete),
            ),),
                Expanded(child: FloatingActionButton(
              onPressed: () => updateGoalButton(goals[index].id!, goals[index].name, goals[index].goalCurrent, goals[index].description, goals[index].goalCurrent, goals[index].goalTarget),
              child: const Icon(Icons.money),
            ),)
              ]
            )
            ),
          ),
        ),
      Row(
        children: <Widget> [
          FloatingActionButton(
        onPressed: _addExpenseCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      FloatingActionButton(
        onPressed: _addGoalCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.home),
      ),
      ])], // This trailing comma makes auto-formatting nicer for build methods.
    )));
  }
}
