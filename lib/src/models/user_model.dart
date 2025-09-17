class UserModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final double height; // in cm
  final double weight; // in kg
  final String region;
  final String? profilePicturePath;
  final String language;
  final bool isDarkMode;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.region,
    this.profilePicturePath,
    this.language = 'en',
    this.isDarkMode = false,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? region,
    String? profilePicturePath,
    String? language,
    bool? isDarkMode,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      region: region ?? this.region,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'region': region,
      'profilePicturePath': profilePicturePath,
      'language': language,
      'isDarkMode': isDarkMode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      region: json['region'],
      profilePicturePath: json['profilePicturePath'],
      language: json['language'] ?? 'en',
      isDarkMode: json['isDarkMode'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
