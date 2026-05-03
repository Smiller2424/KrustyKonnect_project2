import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
          final data = event.data() as Map<String, dynamic>;

          final rsvpUserIds = List<String>.from(data['rsvpUserIds'] ?? []);
          final isAttending = rsvpUserIds.contains(currentUserId);
          final isCreator = data['createdBy'] == currentUserId;

          // ✅ FIXED DATE FORMAT
          final dateTime = data['date'] != null
              ? (data['date'] as Timestamp).toDate()
              : null;

          final formattedDate = dateTime != null
              ? DateFormat('EEEE MMMM d, y \'at\' h:mm a').format(dateTime)
              : 'No date selected';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    data['title'] ?? 'Untitled Event',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                Text("Description: ${data['description'] ?? 'No description'}"),
                const SizedBox(height: 8),

                Text("Location: ${data['location'] ?? 'No location'}"),
                const SizedBox(height: 8),

                Text("Time: $formattedDate"),
                const SizedBox(height: 8),

                Text("RSVPs: ${rsvpUserIds.length}"),
                const SizedBox(height: 30),

                // ✅ BUTTONS SIDE BY SIDE + SIZED
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          if (isAttending) {
                            await eventService.cancelRsvp(
                              eventId: eventId,
                              userId: currentUserId,
                            );
                          } else {
                            await eventService.rsvpToEvent(
                              eventId: eventId,
                              userId: currentUserId,
                            );
                          }

                          await NotificationService().saveDeviceToken();
                        },
                        child: Text(isAttending ? "Leave" : "Join"),
                      ),
                    ),

                    const SizedBox(width: 16),

                    if (isCreator)
                      SizedBox(
                        width: 140,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Event"),
                                  content: const Text("Are you sure you want to delete this event?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (shouldDelete == true) {
                              await FirebaseFirestore.instance
                                  .collection('events')
                                  .doc(eventId)
                                  .delete();

                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Delete"),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
