enum Gender {
  male,
  female,
  other;

  String toJson() => name;

  static Gender fromJson(String value) {
    return Gender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Gender.other,
    );
  }
}
