enum ActivityType {
  meal,
  nap,
  study,
  play,
  medical,
  behavior,
  special,
  other
}

class ActivityModel {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime timestamp;
  final String? iconPath;
  final Map<String, dynamic>? metadata; // e.g., { "food_amount": "all", "mood": "happy" }

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.iconPath,
    this.metadata,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ActivityType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ActivityType.other,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      iconPath: json['iconPath'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'iconPath': iconPath,
      'metadata': metadata,
    };
  }
}
