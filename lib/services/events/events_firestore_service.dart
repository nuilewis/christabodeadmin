import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event_model.dart';

class EventsFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<QuerySnapshot> getEvents({String? year}) async {
    ///To ensure the app will auto update when the year changes
    final String currentYear = DateTime.now().year.toString();

    try {
      QuerySnapshot<Map<String, dynamic>> result = await firestore
          .collection(year ?? currentYear)
          .doc("events")
          .collection("events")
          .get();
      return result;
    } on FirebaseException {
      rethrow;
    }
  }

  ///-------------Write Operations-------------///
  Future<void> addEvent({required Event event}) async {
    final Map<String, dynamic> data = event.toMap();
    final String year = event.startDate.year.toString();
    try {
      await firestore
          .collection(year)
          .doc("events")
          .collection("events")
          .doc()
          .set(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> editEvent({required Event event}) async {
    final Map<String, dynamic> data = event.toMap();
    final String year = event.startDate.year.toString();
    try {
      await firestore
          .collection(year)
          .doc("events")
          .collection("events")
          .doc(event.docId)
          .update(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> deleteEvent({required Event event}) async {
    final String year = event.startDate.year.toString();
    try {
      await firestore
          .collection(year)
          .doc("events")
          .collection("events")
          .doc(event.docId)
          .delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
