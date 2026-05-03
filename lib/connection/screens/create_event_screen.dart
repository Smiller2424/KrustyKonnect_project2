import 'package:flutter/material.dart';
import '../services/event_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final EventService _eventService = EventService();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _createEvent() async {
    if (_titleController.text.isEmpty || _selectedDateTime == null) return;

    await _eventService.createEvent(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      date: _selectedDateTime!,
      createdBy: 'demoUser',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String dateText = _selectedDateTime == null
        ? "Select Event Date & Time"
        : "${_selectedDateTime!.month}/${_selectedDateTime!.day}/${_selectedDateTime!.year} "
          "${TimeOfDay.fromDateTime(_selectedDateTime!).format(context)}";

    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
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
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _pickDateTime,
              child: Text(dateText),
            ),

            const SizedBox(height: 16),

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
