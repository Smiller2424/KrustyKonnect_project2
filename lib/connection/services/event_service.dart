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
    required String location,
  }) async {
    await _eventRepository.createEvent(
      title: title,
      description: description,
      date: date,
      createdBy: createdBy,
      location: location, 
    );
  }

  //to get event for UI
  Stream<QuerySnapshot> getEvents() {
    return _eventRepository.getEvents();
  }

  //rsvp that theyre coming
  Future<void> rsvpToEvent({
    required String eventId,
    required String userId,
  }) {
    return _eventRepository.updateAttendees(
      eventId: eventId,
      userId: userId,
      isComing: true,
    );
  }

  //rsvp not coming
  Future<void> cancelRsvp({
    required String eventId,
    required String userId,
  }) {
    return _eventRepository.updateAttendees(
      eventId: eventId,
      userId: userId,
      isComing: false,
    );
  }
}
