enum GoalType {
  loseWeight,
  maintainWeight,
  gainWeight;

  String toJson() => name;

  static GoalType fromJson(String value) {
    return GoalType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GoalType.maintainWeight,
    );
  }
}
