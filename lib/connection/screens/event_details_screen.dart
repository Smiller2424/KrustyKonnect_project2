import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../services/notification_service.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final String currentUserId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final EventService eventService = EventService();

    return Scaffold(
      appBar: AppBar(title: const Text("Event Details")),
      body: StreamBuilder(
        stream: eventService.getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final event = docs.firstWhere((doc) => doc.id == eventId);
          //check if user already rsvp'd
          final attendees = event['attendees'] ?? [];
          final isAttending = attendees.contains(currentUserId);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: const TextStyle(fontSize: 20)
                ),
                Text("Location: ${event['location']}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if(isAttending) {
                      eventService.cancelRsvp(
                        eventId: eventId,
                        userId: currentUserId,
                      );
                    } else {
                      eventService.rsvpToEvent(
                        eventId: eventId,
                        userId: currentUserId,
                      );
                    }
                    await NotificationService().saveDeviceToken();
                  },
                  //change whether or not they are coming
                  child: Text(isAttending ? "Leave Event" : "Join Event"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}