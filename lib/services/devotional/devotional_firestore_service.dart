import 'package:christabodeadmin/core/date_time_formatter.dart';
import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/devotional_model.dart';

class DevotionalFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<QuerySnapshot> getDevotionals({String? year}) async {
    ///Todo: Update Devotional Read Services
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
    final Map<String, dynamic> devotionalData = devotional.toMap();
    final String year = devotional.startDate.year.toString();
    final String month = monthFromDateTime(devotional.startDate);
    final devotionalDocumentReference = firestore.collection(year).doc("devotional").collection("devotional").doc(month);

    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(devotionalDocumentReference);

        //Parse Data
        if (snapshot.exists) {
          Map<String, dynamic> documentData =
          snapshot.data() as Map<String, dynamic>;

          List<dynamic> devotionalList = documentData["devotional"];

          //now Add the new Hymn to the List
          devotionalList.add(devotionalData);

          //Now update the transaction
          transaction.update(devotionalDocumentReference, {"devotional": devotionalList});
        } else {
          //Case where there is no pre existing data
          transaction.set(
            devotionalDocumentReference,
            {
              "devotional": [devotionalData]
            },
          );
        }
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });


  }

  Future<void> editDevotionalMessage({
    required Devotional devotional,
  }) async {
    final Map<String, dynamic> devotionalData = devotional.toMap();
    final String year = devotional.startDate.year.toString();
    final String month = monthFromDateTime(devotional.startDate);

    final devotionalDocumentReference = firestore.collection(year).doc("devotional").collection("devotional").doc(month);

    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(devotionalDocumentReference);

        //Parse Data

          Map<String, dynamic> documentData =
          snapshot.data() as Map<String, dynamic>;

          List<dynamic> devotionalList = documentData["devotional"];

        //Now update the hymn, can use the index
        int index =
        devotionalList.indexWhere((element) => element["start"] == devotional.startDate);
        devotionalList[index] = devotionalData;

          //Now update the transaction
          transaction.update(devotionalDocumentReference, {"devotional": devotionalList});

      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });

  }

  Future<void> deleteDevotionalMessage({
    required Devotional devotional,
  }) async {
    final String year = devotional.startDate.year.toString();
    final String month = monthFromDateTime(devotional.startDate);

    final devotionalDocumentReference = firestore.collection(year).doc("devotional").collection("devotional").doc(month);

    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(devotionalDocumentReference);

        //Parse Data

        Map<String, dynamic> documentData =
        snapshot.data() as Map<String, dynamic>;

        List<dynamic> devotionalList = documentData["devotional"];

        //Now update the devotional, can use the index to remove the item
        int index =
        devotionalList.indexWhere((element) => element["start"] == devotional.startDate);
        devotionalList.removeAt(index);

        //Now update the transaction
        transaction.update(devotionalDocumentReference, {"devotional": devotionalList});

      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });
  }
}
