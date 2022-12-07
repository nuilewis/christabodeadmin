import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/devotional_model.dart';

class DevotionalFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<QuerySnapshot> getDevotionals({String? year}) async {
    ///To ensure the app will auto update when the year changes
    final String currentYear = DateTime.now().year.toString();

    try {
      QuerySnapshot<Map<String, dynamic>> result = await firestore
          .collection(year ?? currentYear)
          .doc("devotional")
          .collection("devotional")
          .get();
      return result;
    } on FirebaseException {
      rethrow;
    }
  }

  ///-------------Write Operations-------------///
  Future<void> addDevotionalMessage({required Devotional devotional}) async {
    final Map<String, dynamic> data = devotional.toMap();
    final String year = devotional.startDate.year.toString();
    try {
      await firestore
          .collection(year)
          .doc("devotional")
          .collection("devotional")
          .doc()
          .set(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> editDevotionalMessage({
    required Devotional devotional,
  }) async {
    final Map<String, dynamic> data = devotional.toMap();
    final String year = devotional.startDate.year.toString();
    try {
      await firestore
          .collection(year)
          .doc("devotional")
          .collection("devotional")
          .doc(devotional.docId)
          .update(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> deleteDevotionalMessage({
    required Devotional devotional,
  }) async {
    final String year = devotional.startDate.year.toString();
    try {
      await firestore
          .collection(year)
          .doc("devotional")
          .collection("devotional")
          .doc(devotional.docId)
          .delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
