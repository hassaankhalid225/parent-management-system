import 'package:hive/hive.dart';

part 'child_model.g.dart';

@HiveType(typeId: 1)
class ChildModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fullName;
  
  @HiveField(2)
  final String className;
  
  @HiveField(3)
  final String section;
  
  @HiveField(4)
  final String rollNumber;
  
  @HiveField(5)
  final DateTime dateOfBirth;
  
  @HiveField(6)
  final String bloodGroup;
  
  @HiveField(7)
  final String? profilePictureUrl;
  
  @HiveField(8)
  final String gender;
  
  @HiveField(9)
  final List<String>? medicalConditions;
  
  @HiveField(10)
  final int presentDays;
  
  @HiveField(11)
  final int absentDays;
  
  @HiveField(12)
  final double pendingFees;

  ChildModel({
    required this.id,
    required this.fullName,
    required this.className,
    required this.section,
    required this.rollNumber,
    required this.dateOfBirth,
    required this.bloodGroup,
    this.profilePictureUrl,
    required this.gender,
    this.medicalConditions,
    this.presentDays = 0,
    this.absentDays = 0,
    this.pendingFees = 0.0,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      className: json['className'] as String,
      section: json['section'] as String,
      rollNumber: json['rollNumber'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      bloodGroup: json['bloodGroup'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      gender: json['gender'] as String,
      medicalConditions: (json['medicalConditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      presentDays: json['presentDays'] as int? ?? 0,
      absentDays: json['absentDays'] as int? ?? 0,
      pendingFees: (json['pendingFees'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'className': className,
      'section': section,
      'rollNumber': rollNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'bloodGroup': bloodGroup,
      'profilePictureUrl': profilePictureUrl,
      'gender': gender,
      'medicalConditions': medicalConditions,
      'presentDays': presentDays,
      'absentDays': absentDays,
      'pendingFees': pendingFees,
    };
  }

  ChildModel copyWith({
    String? id,
    String? fullName,
    String? className,
    String? section,
    String? rollNumber,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? profilePictureUrl,
    String? gender,
    List<String>? medicalConditions,
    int? presentDays,
    int? absentDays,
    double? pendingFees,
  }) {
    return ChildModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      className: className ?? this.className,
      section: section ?? this.section,
      rollNumber: rollNumber ?? this.rollNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      gender: gender ?? this.gender,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      presentDays: presentDays ?? this.presentDays,
      absentDays: absentDays ?? this.absentDays,
      pendingFees: pendingFees ?? this.pendingFees,
    );
  }

  String get classAndSection => '$className-$section';
  
  int get totalDays => presentDays + absentDays;
  
  double get attendancePercentage {
    if (totalDays == 0) return 0.0;
    return (presentDays / totalDays) * 100;
  }
}
