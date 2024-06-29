import 'package:flutter/material.dart';

import '../database/finance_tables.dart';

import '../model/expense.dart';
import '../model/goal.dart';
import '../model/month_data.dart';

class FinanceProvider with ChangeNotifier {
  FinanceProvider () {
    //Getting the data already
    addBaseExpenses();
    addBaseGoal();
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

  // more dummy testing
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

  void addExpense(int month, int isExpense, int expenseType, int amountToPay) {
    expenses.add(Expense(id: expenses.length, isExpense: isExpense, cost: amountToPay, expenseType: expenseType, linkedGoal: 0, month: month));

    organizeMonths();

    notifyListeners();
  }

  void addExpenseGoal(int month, int goalLink, int amountToPay) {
    expenses.add(Expense(id: expenses.length, isExpense: 1, cost: amountToPay, expenseType: 4, linkedGoal: goalLink, month: month));

    organizeMonths();

    notifyListeners();
  }

  void deleteExpense(int expenseId) {
    //Get proper goalId first
    for(var i = 0; i < expenses.length; i++){
      Expense currentExpense = expenses[i];

      //check if proper goalId
      if (currentExpense.id == expenseId) {
        print('deleting expense...');
        expenses.removeAt(i);
      }
    }

    organizeMonths();

    notifyListeners();
  }

  void addBaseGoal() {
    goals.add(Goal(id: 0, name: 'Test Goal One', goalType: 1, description: 'Test Goal One', goalCurrent: 0, goalTarget: 600));
    goals.add(Goal(id: 1, name: 'Test Goal Two', goalType: 1, description: 'Test Goal Two', goalCurrent: 520, goalTarget: 800));
    goals.add(Goal(id: 2, name: 'Test Goal Three', goalType: 1, description: 'Test Goal Three', goalCurrent: 150, goalTarget: 500));

    notifyListeners();
  }

  void addNewGoal(Goal newGoal) {
    goals.add(newGoal);

    notifyListeners();
  }

  void payForGoal(int goalId, int month, int goalPay) {
    //Get proper goalId first
    for(var i = 0; i < goals.length; i++){
      Goal currentGoal = goals[i];

      //check if proper goalId
      if (currentGoal.id == goalId) {
        //See if goal has reached its limit if adding goal pay
        int targetDifference = currentGoal.goalTarget - currentGoal.goalCurrent;
        int actualPayment = goalPay;

        //paying only as much as needed
        if (targetDifference < goalPay) {
          actualPayment = targetDifference;
        }

        //finally updating
        goals[i].goalCurrent = goals[i].goalCurrent + actualPayment;

        if (actualPayment > 0) {
          addExpenseGoal(month, goalId, actualPayment);
        }
      }
    }

    notifyListeners();
  }

  void deleteGoal(int goalId) {
    //Get proper goalId first
    for(var i = 0; i < goals.length; i++){
      Goal currentGoal = goals[i];

      //check if proper goalId
      if (currentGoal.id == goalId) {
        goals.removeAt(i);
      }
    }

    notifyListeners();
  }

  void organizeMonths() {
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
  }

  //These are the real functions
  void getExpenses() async {
    expenses = await FinanceDatabase.instance.expenses();

    //Take from expenses, and organize into month expenses and income
    organizeMonths();

    notifyListeners();
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

  void getGoals() async {
    goals = await FinanceDatabase.instance.goals();
    notifyListeners();
  }

  
}