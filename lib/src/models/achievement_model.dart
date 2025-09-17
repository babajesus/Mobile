class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String category;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.category,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? category,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'category': category,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      category: json['category'],
    );
  }
}

class LeaderboardEntry {
  final String userId;
  final String name;
  final String region;
  final double score;
  final int rank;
  final String? profilePicturePath;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.region,
    required this.score,
    required this.rank,
    this.profilePicturePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'region': region,
      'score': score,
      'rank': rank,
      'profilePicturePath': profilePicturePath,
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'],
      name: json['name'],
      region: json['region'],
      score: json['score'].toDouble(),
      rank: json['rank'],
      profilePicturePath: json['profilePicturePath'],
    );
  }
}
