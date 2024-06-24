const String _expenseTable = 'expenses';

//Income and expenses effectively run off the same data

class Expense {
  final int id;
  final bool isExpense;
  final int cost;
  final int expenseType;
  
  final int month;

  const Expense({
    required this.id,
    required this.isExpense,
    required this.cost,
    required this.expenseType,
    required this.month
  });

  Map<String, Object?> toMap() {
    return {
      'id' : id,
      'isExpense' : isExpense,
      'cost' : cost,
      'expenseType' : expenseType,
      'month' : month,
    };
  }

  @override
  String toString() {
    return 'Expense{id: $id, isExpense, $isExpense, cost: $cost, expenseType: $expenseType, month: $month}';
  }
}

//Not doing major manipulation, just add, delete, and filters

Future<void> addExpense(Expense expense) async {
  final db = await database;

  await db.insert(
    _expenseTable,
    expense.toMap(),
  );
}

Future<void> deleteExpense(int id) async {
  final db = await database;

  await db.delete(
    _expenseTable,
    where: 'id = ?',
    whereArgs: [id],
  )
}

Future<void> filterExpenses(int expenseType, int month) async {
  final db = await database;

  await db.delete(
    _expenseTable,
    where: 'id = ?',
    whereArgs: [id],
  )
}

Future<void> filterIncome(int incomeType, int month) async {
  final db = await database;

  await db.delete(
    _expenseTable,
    where: 'id = ?',
    whereArgs: [id],
  )
}