import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/prayer_model.dart';

class PrayerFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<QuerySnapshot> getPrayers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> result =
          await firestore.collection("prayers").get();
      return result;
    } on FirebaseException {
      rethrow;
    }
  }

  ///-------------Write Operations-------------///
  Future<void> addPrayer({required Prayer prayer}) async {
    final Map<String, dynamic> data = prayer.toMap();
    try {
      await firestore.collection("prayer").doc().set(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> editPrayer({
    required Prayer prayer,
  }) async {
    final Map<String, dynamic> data = prayer.toMap();
    try {
      await firestore.collection("prayer").doc(prayer.docId).update(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> deletePrayer({
    required Prayer prayer,
  }) async {
    try {
      await firestore.collection("prayer").doc(prayer.docId).delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
