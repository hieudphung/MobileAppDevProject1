import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/expense.dart';

//Expense database here
const String _expenseTable = 'expenses';

class ExpenseDatabase {
  static final ExpenseDatabase instance = ExpenseDatabase._init();

  static Database? _database;

  ExpenseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

      await db.execute(
        '''
      CREATE TABLE IF NOT EXISTS $_expenseTable ( 
    ${ExpenseFields.id} $idType, 
    ${ExpenseFields.isExpense} $boolType,
    ${ExpenseFields.cost} $integerType,
    ${ExpenseFields.expenseType} $integerType,
    ${ExpenseFields.month} $integerType,
    )
  ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

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
              ExpenseFields.isExpense : isExpense as bool,
              ExpenseFields.cost : cost as int,
              ExpenseFields.expenseType : expenseType as int,
              ExpenseFields.month : month as int,
            } in expenseMap)
          Expense(id: id, isExpense: isExpense, cost: cost, expenseType: expenseType, month: month),
      ];
    }

  Future<List<Expense>> filterExpenses(bool expenseFilter, int typeFilter, int monthFilter) async {
    final db = await instance.database;

      final List<Map<String, Object?>> expenseMap = await db.rawQuery(
        '''
      SELECT * FROM $_expenseTable where 
      ${ExpenseFields.isExpense}=?, 
      ${ExpenseFields.expenseType}=?, 
      ${ExpenseFields.month}=?
        ''', 
        [expenseFilter, typeFilter, monthFilter]);
        
      return [
        for (final {
              ExpenseFields.id : id as int,
              ExpenseFields.isExpense : isExpense as bool,
              ExpenseFields.cost : cost as int,
              ExpenseFields.expenseType : expenseType as int,
              ExpenseFields.month : month as int,
            } in expenseMap)
          Expense(id: id, isExpense: isExpense, cost: cost, expenseType: expenseType, month: month),
      ];
  }
}