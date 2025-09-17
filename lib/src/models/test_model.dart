enum TestType {
  verticalJump,
  shuttleRun,
  situps,
  enduranceRun,
  heightWeight,
}

class TestResult {
  final String id;
  final String userId;
  final TestType testType;
  final double score;
  final String unit;
  final DateTime completedAt;
  final Map<String, dynamic>? metadata;

  TestResult({
    required this.id,
    required this.userId,
    required this.testType,
    required this.score,
    required this.unit,
    required this.completedAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'testType': testType.name,
      'score': score,
      'unit': unit,
      'completedAt': completedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'],
      userId: json['userId'],
      testType: TestType.values.firstWhere((e) => e.name == json['testType']),
      score: json['score'].toDouble(),
      unit: json['unit'],
      completedAt: DateTime.parse(json['completedAt']),
      metadata: json['metadata'],
    );
  }
}

class TestInfo {
  final TestType type;
  final String name;
  final String description;
  final String icon;
  final String demoVideoPath;
  final String unit;
  final Map<String, double> benchmarks; // age/gender -> score

  const TestInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.demoVideoPath,
    required this.unit,
    required this.benchmarks,
  });
}
