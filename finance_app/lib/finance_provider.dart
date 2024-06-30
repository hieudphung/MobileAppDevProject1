import 'package:flutter/material.dart';

import '../database/finance_tables.dart';

import '../model/expense.dart';
import '../model/goal.dart';
import '../model/month_data.dart';

class FinanceProvider with ChangeNotifier {
  FinanceProvider () {
    //Getting the data already

    fetchExpenses();
    
    expensesLoaded = fetchExpenses();
    goalLoaded = fetchGoals();

    notifyListeners();
  }

  @override
  void dispose() {
    FinanceDatabase.instance.close();

    super.dispose();
  }

  /*
  This is for managing the backend, where certain elements in the program will listen to this.
  It's also meant to keep returned data from the database in a consistent place, as it gets passed around.
  */

  //All the variables shared and called down the line
  List<Expense> expenses = List.empty(growable: true);
  List<MonthData> monthDatasets = List.empty(growable: true);
  List<Goal> goals = List.empty(growable: true);

  late Future expensesLoaded;
  late Future goalLoaded;

  // just for dummy testing
  void addBaseExpenses() {
    
    expenses.add(const Expense(id: 0, isExpense: 1, cost: 70, expenseType: 1, linkedGoal: 0, month: 6));
    expenses.add(const Expense(id: 1, isExpense: 1, cost: 20, expenseType: 2, linkedGoal: 0, month: 6));
    expenses.add(const Expense(id: 2, isExpense: 1, cost: 30, expenseType: 3, linkedGoal: 0, month: 6));
    expenses.add(const Expense(id: 3, isExpense: 1, cost: 40, expenseType: 4, linkedGoal: 1, month: 6));

    expenses.add(const Expense(id: 4, isExpense: 2, cost: 40, expenseType: 1, linkedGoal: 0, month: 6));
    expenses.add(const Expense(id: 5, isExpense: 2, cost: 60, expenseType: 2, linkedGoal: 0, month: 6));
    expenses.add(const Expense(id: 6, isExpense: 2, cost: 80, expenseType: 3, linkedGoal: 0, month: 6));

    expenses.add(const Expense(id: 7, isExpense: 1, cost: 70, expenseType: 1, linkedGoal: 0, month: 5));
    expenses.add(const Expense(id: 8, isExpense: 1, cost: 20, expenseType: 2, linkedGoal: 0, month: 5));
    expenses.add(const Expense(id: 9, isExpense: 1, cost: 30, expenseType: 3, linkedGoal: 0, month: 5));

    expenses.add(const Expense(id: 10, isExpense: 2, cost: 40, expenseType: 1, linkedGoal: 0, month: 5));
    expenses.add(const Expense(id: 11, isExpense: 2, cost: 80, expenseType: 3, linkedGoal: 0, month: 5));

    organizeMonths();

    notifyListeners();
  }

  Future<void> fetchExpenses() async {
    expenses = await FinanceDatabase.instance.expenses();

    expensesLoaded = organizeMonths();
    //return true;
  }

  Future<void> addExpense(int month, int isExpense, int expenseType, int amountToPay) async {
    Expense newExpense = Expense(isExpense: isExpense, cost: amountToPay, expenseType: expenseType, linkedGoal: 0, month: month);

    await FinanceDatabase.instance.addExpense(newExpense);
    //expenses.add();

    expensesLoaded = fetchExpenses();

    notifyListeners();
  }

  Future<void> addExpenseGoal(int month, int goalLink, int amountToPay) async {
    Expense newExpense = Expense(isExpense: 1, cost: amountToPay, expenseType: 4, linkedGoal: goalLink, month: month);

    await FinanceDatabase.instance.addExpense(newExpense);
    //expenses.add(Expense(id: expenses.length, isExpense: 1, cost: amountToPay, expenseType: 4, linkedGoal: goalLink, month: month));

    expensesLoaded = fetchExpenses();

    notifyListeners();
  }

  Future<void> deleteExpense(int expenseId) async {

    //Get the existing expense from id to check if linked to a goal
    //Get proper goalId first
    for(var i = 0; i < expenses.length; i++) {
      Expense currentExpense = expenses[i];

      //check if proper goalId
      if (currentExpense.id == expenseId) {
        
        //check if it has a linked goal
        if (currentExpense.linkedGoal != 0) {
          payForGoal(currentExpense.linkedGoal, 0, -currentExpense.cost);
        }
      }
    }

    await FinanceDatabase.instance.deleteExpense(expenseId);

    expensesLoaded = fetchExpenses();

    notifyListeners();
  }

  Future<bool> fetchGoals() async {
    goals = await FinanceDatabase.instance.goals();

    return true;
  }

  //Just a dummy function
  void addBaseGoal() {
    goals.add(Goal(id: 0, name: 'Test Goal One', goalType: 1, description: 'Test Goal One', goalCurrent: 0, goalTarget: 600));
    goals.add(Goal(id: 1, name: 'Test Goal Two', goalType: 1, description: 'Test Goal Two', goalCurrent: 520, goalTarget: 800));
    goals.add(Goal(id: 2, name: 'Test Goal Three', goalType: 1, description: 'Test Goal Three', goalCurrent: 150, goalTarget: 500));

    notifyListeners();
  }

  Future<void> addNewGoal(String goalName, int goalType, String description, int goalAmount) async {
    //dummy step
    //goals.add(newGoal);

    Goal newGoal = Goal(name: goalName, goalType: goalType, description: description, goalCurrent: 0, goalTarget: goalAmount);
    await FinanceDatabase.instance.addGoal(newGoal);

    goalLoaded = fetchGoals();

    notifyListeners();
  }

  //To confirm a payable goal
  Future<void> payForGoal(int goalId, int month, int goalPay) async {
    // Get proper goalId first
    for(var i = 0; i < goals.length; i++){
      Goal currentGoal = goals[i];

      // check if proper goalId
      if (currentGoal.id == goalId) {
        

        //check if adding of subbing
        if (goalPay > 0) {
          // See if goal has reached its limit if adding goal pay
          int targetDifference = currentGoal.goalTarget - currentGoal.goalCurrent;
          int actualPayment = goalPay;

          // paying only as much as needed
          if (targetDifference < goalPay) {
            actualPayment = targetDifference;
          }

          //finally updating
          //goals[i].goalCurrent = goals[i].goalCurrent + actualPayment;
          currentGoal.goalCurrent = currentGoal.goalCurrent + actualPayment;

          if (actualPayment > 0) {
            addExpenseGoal(month, goalId, actualPayment);
            await FinanceDatabase.instance.updateGoal(currentGoal);
          }
        } else {
          // subbing
          int subDifference = currentGoal.goalCurrent + goalPay;

          if (subDifference < 0) {
            subDifference = 0;
          }

          currentGoal.goalCurrent = subDifference;
          await FinanceDatabase.instance.updateGoal(currentGoal);
        }
      }
    }

    goalLoaded = fetchGoals();

    notifyListeners();
  }

  Future<void> deleteGoal(int goalId) async {
    await FinanceDatabase.instance.deleteGoal(goalId);

    goalLoaded = fetchGoals();

    notifyListeners();
  }

  Future<void> organizeMonths() async {
    //Reset the months first
    monthDatasets = List.empty(growable: true);

    //They should be organized by months, if all expenses are taken
    
    //Iterate by available months
    for (var month = 6; month > 0; month--) {
      //bins for expenses
      double totalGroceries = 0;
      double totalInsurance = 0;
      double totalBills = 0;
      double totalGoalpays = 0;

      double totalIncome = 0;
      double totalExtraIncome = 0;

      //Not efficient, but gets it done
      for (var i = 0; i < expenses.length; i++) {
        Expense currentExpense = expenses[i];

        //See if it's in the same month
        if (currentExpense.month == month) {
          //Determine if expense or income
          //Not a bool for storage sake, but effectively just seeing if true
          if (currentExpense.isExpense == 1) {
            switch (currentExpense.expenseType) {
              case 1:
                totalGroceries += currentExpense.cost;
              case 2:
                totalInsurance += currentExpense.cost;
              case 3:
                totalBills += currentExpense.cost;
              case 4:
                totalGoalpays += currentExpense.cost;
              default:
                totalGroceries += currentExpense.cost;
            }
          } else {
            switch (currentExpense.expenseType) {
              case 1:
                totalIncome += currentExpense.cost;
              default:
                totalExtraIncome += currentExpense.cost;
            }
          }
        }
      }

      int intTotalExpense = (totalGroceries + totalInsurance + totalBills + totalGoalpays).round();
      int intTotalIncome = (totalIncome + totalExtraIncome).round();

      monthDatasets.add(
        MonthData(
          monthNumber: month,
          totalExpense: intTotalExpense,
          expenseDataset: { 'Groceries': totalGroceries , 'Insurance': totalInsurance , 'Bills': totalBills , 'Goal Pay' : totalGoalpays},
          totalIncome: intTotalIncome,
          incomeDataset: { 'Income': totalIncome, 'Extra Income': totalExtraIncome }
        ),
      );
    }

    //return true;
  }

  List<Expense> getExpensesByMonth(int getMonth) {
    List<Expense> returningExpense = List.empty(growable:true);

    for (var i = 0; i < expenses.length; i++) {
      Expense currentExpense = expenses[i];

      if (currentExpense.isExpense == 1 && currentExpense.month == getMonth) {
        returningExpense.add(currentExpense);
      }
    }

    return returningExpense;
  }

  List<Expense> getExpensesByGoal(int goalId) {
    List<Expense> returningExpense = List.empty(growable:true);

    for (var i = 0; i < expenses.length; i++) {
      Expense currentExpense = expenses[i];

      if (currentExpense.isExpense == 1 && currentExpense.linkedGoal == goalId) {
        returningExpense.add(currentExpense);
      }
    }

    return returningExpense;
  }

  List<Expense> getIncomeByMonth(int getMonth) {
    List<Expense> returningIncome = List.empty(growable:true);

    for (var i = 0; i < expenses.length; i++) {
      Expense currentExpense = expenses[i];

      if (currentExpense.isExpense != 1 && currentExpense.month == getMonth) {
        returningIncome.add(currentExpense);
      }
    }

    return returningIncome;
  }
}