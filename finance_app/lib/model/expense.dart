//Income and expenses effectively run off the same data

class ExpenseFields {
  //Fields here
  static final List<String> values = [id, isExpense, cost, expenseType, month];

  static const String id = 'id';
  static const String isExpense = 'isExpense';
  static const String cost = 'cost';
  static const String expenseType = 'expenseType';
  static const String linkedGoal = 'linkedGoal';
  static const String month = 'month';
}

class Expense {
  const Expense({
    this.id,
    required this.isExpense,
    required this.cost,
    required this.expenseType,
    required this.linkedGoal,
    required this.month
  });

  final int? id;
  final int isExpense;    //NOTE: isExpense is an integer, but is functionally supposed to be a boolean, just SQL doesn't take bool
  final int cost;
  final int expenseType;
  final int linkedGoal;   //Not used all the time, but if there are goal-based expenses, get from here
  final int month;

  Map<String, Object?> toMap() {
    return {
      'id' : id,
      'isExpense' : isExpense,
      'cost' : cost,
      'expenseType' : expenseType,
      'linkedGoal' : linkedGoal,
      'month' : month,
    };
  }

  @override
  String toString() {
    return 'Expense{id: $id, isExpense, $isExpense, cost: $cost, expenseType: $expenseType, linkedGoal: $linkedGoal, month: $month}';
  }

  factory Expense.fromJson(Map<String, dynamic> data) {
    return Expense(
      id: data["id"],
      isExpense: data["isExpense"],
      cost: data["cost"],
      expenseType: data["expenseType"],
      linkedGoal: data["linkedGoal"],
      month: data["month"],
    );
  }

  Map<String, dynamic> toJson() => {
      "id": id,
      "isExpense": isExpense,
      "cost": cost,
      "expenseType": expenseType,
      "linkedGoal": linkedGoal,
      "month": month
  };
}

