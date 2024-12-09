class CityData {
  final int userCount;
  final double avgSalary;
  final double avgAge;

  CityData({
    required this.userCount,
    required this.avgSalary,
    required this.avgAge,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      userCount: json['id'] as int,
      avgSalary: json['salary'] as double,
      avgAge: json['age'] as double,
    );
  }
}
