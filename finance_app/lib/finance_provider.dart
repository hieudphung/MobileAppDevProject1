import 'package:flutter/material.dart';

import '../database/finance_tables.dart';

import '../model/expense.dart';
import '../model/goal.dart';
import '../model/month_data.dart';

class FinanceProvider with ChangeNotifier {
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
    monthDatasets.add(
      const MonthData(
        monthNumber: 6,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 5,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 4,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 3,
        totalExpense: 150,
        expenseDataset: { "None" : 0 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 2,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    monthDatasets.add(
      const MonthData(
        monthNumber: 1,
        totalExpense: 150,
        expenseDataset: { "Expense A": 7, "Expense B": 2, "Expense C": 3 },
        totalIncome: 300,
        incomeDataset: { "Expense A": 4, "Expense B": 6, "Expense C": 9 }
      ),
    );

    notifyListeners();
  }

  void addBaseGoal() {
    goals.add(Goal(id: 0, name: 'Test Goal One', goalType: 1, description: 'Test Goal One', goalCurrent: 0, goalTarget: 600));
    goals.add(Goal(id: 1, name: 'Test Goal Two', goalType: 1, description: 'Test Goal Two', goalCurrent: 520, goalTarget: 800));
    goals.add(Goal(id: 2, name: 'Test Goal Three', goalType: 1, description: 'Test Goal Three', goalCurrent: 150, goalTarget: 500));

    notifyListeners();
  }

  void addNewGoal(Goal newGoal) {
    //goals.add(const Goal(id: 2, name: 'Test Goal New', goalType: 1, description: 'Test Goal New', goalCurrent: 80, goalTarget: 670));

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
      }
    }

    notifyListeners();
  }

  void organizeMonths() {
    //They should be organized by months, if all expenses are taken
    
  }

  //These are the real functions
  void getExpenses() async {
    expenses = await FinanceDatabase.instance.expenses();

    //Take from expenses, and organize into month expenses and income
    organizeMonths();

    notifyListeners();
  }

  void getGoals() async {
    goals = await FinanceDatabase.instance.goals();
    notifyListeners();
  }

  
}