import 'package:pms/features/diary/data/models/activity_model.dart';

class DiaryEntryModel {
  final String id;
  final String childId;
  final DateTime date;
  final List<ActivityModel> activities;
  final String? teacherNote;
  final String? teacherName;
  final List<String> mediaUrls;
  final List<DiaryComment>? comments;

  DiaryEntryModel({
    required this.id,
    required this.childId,
    required this.date,
    required this.activities,
    this.teacherNote,
    this.teacherName,
    this.mediaUrls = const [],
    this.comments = const [],
  });

  factory DiaryEntryModel.fromJson(Map<String, dynamic> json) {
    return DiaryEntryModel(
      id: json['id'],
      childId: json['childId'],
      date: DateTime.parse(json['date']),
      activities: (json['activities'] as List)
          .map((a) => ActivityModel.fromJson(a))
          .toList(),
      teacherNote: json['teacherNote'],
      teacherName: json['teacherName'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      comments: (json['comments'] as List?)
          ?.map((c) => DiaryComment.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'date': date.toIso8601String(),
      'activities': activities.map((a) => a.toJson()).toList(),
      'teacherNote': teacherNote,
      'teacherName': teacherName,
      'mediaUrls': mediaUrls,
      'comments': comments?.map((c) => c.toJson()).toList(),
    };
  }

  DiaryEntryModel copyWith({
    String? id,
    String? childId,
    DateTime? date,
    List<ActivityModel>? activities,
    String? teacherNote,
    String? teacherName,
    List<String>? mediaUrls,
    List<DiaryComment>? comments,
  }) {
    return DiaryEntryModel(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      date: date ?? this.date,
      activities: activities ?? this.activities,
      teacherNote: teacherNote ?? this.teacherNote,
      teacherName: teacherName ?? this.teacherName,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      comments: comments ?? this.comments,
    );
  }
}

class DiaryComment {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;
  final String? userType; // 'parent' or 'teacher'

  DiaryComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
    this.userType,
  });

  factory DiaryComment.fromJson(Map<String, dynamic> json) {
    return DiaryComment(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'userType': userType,
    };
  }
}
