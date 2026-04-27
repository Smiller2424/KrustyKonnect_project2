import 'package:cloud_firestore/cloud_firestore.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'events';

  //Create new event
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String createdBy,
  }) async {
    await _firestore.collection(_collection).add({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //get all the events
  Stream<QuerySnapshot> getEvents() {
    return _firestore
      .collection(_collection)
      .orderBy('date', descending: false)
      .snapshots();
  }
}
