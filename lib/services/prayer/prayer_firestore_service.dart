import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/date_time_formatter.dart';
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
    final Map<String, dynamic> prayerData = prayer.toMap();
    final String month = monthFromDateTime(prayer.date);
    final prayerDocumentReference = firestore.collection("prayer").doc(month);

    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(prayerDocumentReference);

        //Parse Data
        if (snapshot.exists) {
          Map<String, dynamic> documentData =
          snapshot.data() as Map<String, dynamic>;

          List<dynamic> prayerList = documentData["prayer"];

          //now Add the new Hymn to the List
          prayerList.add(prayerData);

          //Now update the transaction
          transaction.update(prayerDocumentReference, {"prayer": prayerList});
        } else {
          //Case where there is no pre existing data
          transaction.set(
            prayerDocumentReference,
            {
              "prayer": [prayerData]
            },
          );
        }
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });
  }

  Future<void> editPrayer({
    required Prayer prayer,
  }) async {
    final Map<String, dynamic> prayerData = prayer.toMap();
    final String month = monthFromDateTime(prayer.date);
    final prayerDocumentReference = firestore.collection("prayer").doc(month);


    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(prayerDocumentReference);

        //Parse Data

        Map<String, dynamic> documentData =
        snapshot.data() as Map<String, dynamic>;

        List<dynamic> prayerList = documentData["prayer"];

        //Now update the prayer, can use the index to find the prayer to update
        int index =
        prayerList.indexWhere((element) => element["date"] == prayer.date);
        prayerList[index] = prayerData;

        //Now update the transaction
        transaction.update(prayerDocumentReference, {"prayer": prayerList});

      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });
  }

  Future<void> deletePrayer({
    required Prayer prayer,
  }) async {
    final String month = monthFromDateTime(prayer.date);
    final prayerDocumentReference = firestore.collection("prayer").doc(month);


    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(prayerDocumentReference);

        //Parse Data

        Map<String, dynamic> documentData =
        snapshot.data() as Map<String, dynamic>;

        List<dynamic> prayerList = documentData["prayer"];

        //Now update the prayer can use the index to remove the item
        prayerList.indexWhere((element) => element["date"] == prayer.date);
        prayerList.remove(prayer);


        //Now update the transaction
        transaction.update(prayerDocumentReference, {"prayer": prayerList});

      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });
  }

}
