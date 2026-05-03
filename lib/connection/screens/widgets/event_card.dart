import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Timestamp? timestamp = event['date'];
    final DateTime? dateTime = timestamp?.toDate();

    final String formattedDate = dateTime != null
        ? DateFormat('EEEE MMMM d, y \'at\' h:mm a').format(dateTime)
        : 'No date';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(event['title'] ?? 'No Title'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ${event['location'] ?? 'No location'}"),
            Text("Time: $formattedDate"),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}