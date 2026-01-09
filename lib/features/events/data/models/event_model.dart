enum EventType {
  holiday,
  academic,
  sports,
  cultural,
  meeting,
  other
}

enum RsvpStatus {
  going,
  notGoing,
  maybe,
  none
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? startTime;
  final String? endTime;
  final String location;
  final EventType type;
  final String? organizer;
  final List<String>? images;
  final RsvpStatus rsvpStatus;
  final bool isRsvpRequired;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.startTime,
    this.endTime,
    required this.location,
    required this.type,
    this.organizer,
    this.images,
    this.rsvpStatus = RsvpStatus.none,
    this.isRsvpRequired = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      type: EventType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => EventType.other,
      ),
      organizer: json['organizer'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      rsvpStatus: RsvpStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['rsvpStatus'],
        orElse: () => RsvpStatus.none,
      ),
      isRsvpRequired: json['isRsvpRequired'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'type': type.toString().split('.').last,
      'organizer': organizer,
      'images': images,
      'rsvpStatus': rsvpStatus.toString().split('.').last,
      'isRsvpRequired': isRsvpRequired,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    EventType? type,
    String? organizer,
    List<String>? images,
    RsvpStatus? rsvpStatus,
    bool? isRsvpRequired,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      organizer: organizer ?? this.organizer,
      images: images ?? this.images,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
      isRsvpRequired: isRsvpRequired ?? this.isRsvpRequired,
    );
  }
}
