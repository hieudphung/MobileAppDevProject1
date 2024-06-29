//Not used in the database, but for re-organizing expenses for month expense / income cards

class MonthData {
 MonthData({
    required this.monthNumber,
    required this.totalExpense,
    required this.expenseDataset,
    required this.totalIncome,
    required this.incomeDataset
  });
  
  final int monthNumber;
  final int totalExpense;
  final Map<String, double> expenseDataset;
  final int totalIncome;
  final Map<String, double> incomeDataset;
}