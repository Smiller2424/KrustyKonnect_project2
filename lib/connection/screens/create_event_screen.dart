import 'package:flutter/material.dart';
import '../services/event_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  final EventService _eventService = EventService();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if(picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _createEvent() async {
    if (_selectedDate == null) return;

    await _eventService.createEvent(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      date: _selectedDate!,
      createdBy: "testUser" //REPLACE LATER W AUTH USER
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text ("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text("Select Event Date"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _createEvent,
              child: const Text("Create Event"),
            ),
          ],
        ),
      ),
    );
  }
}