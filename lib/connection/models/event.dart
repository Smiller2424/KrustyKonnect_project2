class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime? dateTime;
  final List<String> rsvpUserIds;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    this.dateTime,
    required this.rsvpUserIds,
  });

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      dateTime: map['dateTime'] != null
          ? DateTime.parse(map['dateTime'])
          : null,
      rsvpUserIds: List<String>.from(map['rsvpUserIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'dateTime': dateTime?.toIso8601String(),
      'rsvpUserIds': rsvpUserIds,
    };
  }
}
