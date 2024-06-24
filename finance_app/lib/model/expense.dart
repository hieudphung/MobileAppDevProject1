//Income and expenses effectively run off the same data

class ExpenseFields {
  //Fields here
  static final List<String> values = [id, isExpense, cost, expenseType, month];

  static const String id = 'id';
  static const String isExpense = 'isExpense';
  static const String cost = 'cost';
  static const String expenseType = 'expenseType';
  static const String month = 'month';
}

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

  factory Expense.fromJson(Map<String, dynamic> data) {
    return Expense(
      id: data["id"],
      isExpense: data["isExpense"],
      cost: data["cost"],
      expenseType: data["expenseType"],
      month: data["month"],
    );
  }

  Map<String, dynamic> toJson() => {
      "id": id,
      "isExpense": isExpense,
      "cost": cost,
      "email": expenseType,
      "month": month
  };
}

