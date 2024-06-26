import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/expense.dart';
import '../model/goal.dart';

//Expense database here
const String _expenseTable = 'expenses';
const String _goalTable = 'goals';

class FinanceDatabase {
  static final FinanceDatabase instance = FinanceDatabase._init();

  static Database? _database;

  FinanceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('finances_table.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const stringType = 'TEXT NOT NULL';

    db.execute(
      '''
    CREATE TABLE $_expenseTable ( 
    ${ExpenseFields.id} $idType, 
    ${ExpenseFields.isExpense} $integerType,
    ${ExpenseFields.cost} $integerType,
    ${ExpenseFields.expenseType} $integerType,
    ${ExpenseFields.month} $integerType
    );
  ''');

    db.execute(
      '''
    CREATE TABLE $_goalTable (
    ${GoalFields.id} $idType, 
    ${GoalFields.name} $stringType,
    ${GoalFields.goalType} $integerType,
    ${GoalFields.description} $stringType,
    ${GoalFields.goalCurrent} $integerType,
    ${GoalFields.goalTarget} $integerType
    );
  ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }


  //Everything below for the Expense Table
  //Not doing major manipulation, just add, delete, and filters

  Future<void> addExpense(Expense expense) async {
    final db = await instance.database;

    await db.insert(
      _expenseTable,
      expense.toMap(),
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await instance.database;

    await db.delete(
      _expenseTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // For getting expenses and income
  Future<List<Expense>> expenses() async {
    final db = await instance.database;

    final List<Map<String, Object?>> expenseMap = await db.query(_expenseTable);

    return [
      for (final {
            ExpenseFields.id : id as int,
            ExpenseFields.isExpense : isExpense as int,
            ExpenseFields.cost : cost as int,
            ExpenseFields.expenseType : expenseType as int,
            ExpenseFields.month : month as int,
          } in expenseMap)
        Expense(id: id, isExpense: isExpense, cost: cost, expenseType: expenseType, month: month),
    ];
  }

  Future<List<Expense>> filterExpenses(int expenseFilter, int monthFilter) async {
    final db = await instance.database;

    final List<Map<String, Object?>> expenseMap = await db.rawQuery(
        '''
      SELECT * FROM $_expenseTable where 
      ${ExpenseFields.isExpense}=? AND
      ${ExpenseFields.month}=?
      ORDER BY ${ExpenseFields.expenseType}''', 
        [expenseFilter, monthFilter]);
        
    return [
      for (final {
            ExpenseFields.id : id as int,
            ExpenseFields.isExpense : isExpense as int,
            ExpenseFields.cost : cost as int,
            ExpenseFields.expenseType : expenseType as int,
            ExpenseFields.month : month as int,
          } in expenseMap)
        Expense(id: id, isExpense: isExpense, cost: cost, expenseType: expenseType, month: month),
    ];
  }

  //For the Goals Table
  //Only one that needs updating moneyc

  Future<void> addGoal(Goal goal) async {
    final db = await instance.database;

    await db.insert(
      _goalTable,
      goal.toMap(),
    );
  }

  Future<void> deleteGoal(int id) async {
    final db = await instance.database;

    await db.delete(
      _goalTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateGoal(Goal updatedGoal) async {
    final db = await instance.database;

    db.update(_goalTable, updatedGoal.toMap(),
        where: 'id = ?', 
        whereArgs: [updatedGoal.id]);
  }

  Future<List<Goal>> goals() async {
    final db = await instance.database;

    final List<Map<String, Object?>> goalMap = await db.query(_goalTable);

    return [
      for (final {
            GoalFields.id : id as int,
            GoalFields.name : name as String,
            GoalFields.goalType : goalType as int,
            GoalFields.description : description as String,
            GoalFields.goalCurrent : goalCurrent as int,
            GoalFields.goalTarget : goalTarget as int,
          } in goalMap)
        Goal(id: id, name: name, goalType: goalType, description: description, goalCurrent: goalCurrent, goalTarget: goalTarget),
    ];
  }
}