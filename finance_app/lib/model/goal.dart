//Income and expenses effectively run off the same data

class GoalFields {
  //Fields here
  static final List<String> values = [id, name, goalType, description, goalCurrent, goalTarget];

  static const String id = 'id';
  static const String name = 'name';
  static const String goalType = 'goalType';
  static const String description = 'description';
  static const String goalCurrent = 'goalCurrent';
  static const String goalTarget = 'goalTarget';
}

class Goal {
  final int? id;
  final String name;    //NOTE: isExpense is an integer, but is functionally supposed to be a boolean, just SQL doesn't take bool
  final int goalType;
  final String description;
  final int goalCurrent;
  final int goalTarget;

  const Goal({
    this.id,
    required this.name,
    required this.goalType,
    required this.description,
    required this.goalCurrent,
    required this.goalTarget
  });

  Map<String, Object?> toMap() {
    return {
      'id' : id,
      'name' : name,
      'goalType' : goalType,
      'description' : description,
      'goalCurrent' : goalCurrent,
      'goalTarget' : goalTarget,
    };
  }

  @override
  String toString() {
    return 'Expense{id: $id, name: $name, goalType: $goalType, description: $description, goalCurrent: $goalCurrent, goalTargets: $goalTarget}';
  }

  factory Goal.fromJson(Map<String, dynamic> data) {
    return Goal(
      id: data["id"],
      name: data["name"],
      goalType: data["goalType"],
      description: data["description"],
      goalCurrent: data["goalCurrent"],
      goalTarget: data["goalTarget"],
    );
  }

  Map<String, dynamic> toJson() => {
      "id": id,
      "name" : name,
      "goalType": goalType,
      "description": description,
      "goalCurrent": goalCurrent,
      "goalTarget": goalTarget
  };
}
