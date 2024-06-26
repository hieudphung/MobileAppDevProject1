import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String _expenseTable = 'expenses';

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
    required this.month,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'isExpense': isExpense ? 1 : 0,
      'cost': cost,
      'expenseType': expenseType,
      'month': month,
    };
  }

  @override
  String toString() {
    return 'Expense{id: $id, isExpense: $isExpense, cost: $cost, expenseType: $expenseType, month: $month}';
  }
}

Future<Database> get database async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'expenses.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_expenseTable(id INTEGER PRIMARY KEY, isExpense INTEGER, cost INTEGER, expenseType INTEGER, month INTEGER)',
      );
    },
    version: 1,
  );
}

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
  );
}

Future<List<Expense>> getExpenses() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(_expenseTable);

  return List.generate(maps.length, (i) {
    return Expense(
      id: maps[i]['id'],
      isExpense: maps[i]['isExpense'] == 1,
      cost: maps[i]['cost'],
      expenseType: maps[i]['expenseType'],
      month: maps[i]['month'],
    );
  });
}
