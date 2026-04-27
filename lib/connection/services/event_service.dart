import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/event_repository.dart';

class EventService {
  final EventRepository _eventRepository = EventRepository();

  //create event
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String createdBy,
  }) async {
    try {
      await _eventRepository.createEvent(
        title: title,
        description: description,
        date: date,
        createdBy: createdBy,
      );
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  //to get event for UI
  Stream<QuerySnapshot> getEvents() {
    return _eventRepository.getEvents();
  }
}
