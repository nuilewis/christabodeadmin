import 'package:christabodeadmin/core/date_time_formatter.dart';
import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/devotional_model.dart';

class DevotionalFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getDevotionals(
      {String? year}) async {

    ///To ensure the app will auto update when the year changes
    final String currentYear = DateTime.now().year.toString();
    final devotionalDocumentReference =
        firestore.collection("2024").doc("devotional").collection("devotional");

    Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        devotionalDocumentReference.snapshots();
    return stream;
  }

  ///-------------Write Operations-------------///
  Future<void> addDevotionalMessage({required Devotional devotional}) async {
    final Map<String, dynamic> devotionalData = devotional.toMap();
    final String year = devotional.startDate.year.toString();
    final String month = monthFromDateTime(devotional.startDate);
    final devotionalDocumentReference = firestore
        .collection(year)
        .doc("devotional")
        .collection("devotional")
        .doc(month);



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
          transaction.update(
              devotionalDocumentReference, {"devotional": devotionalList});
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
    required Devotional oldDevotional,
    required Devotional newDevotional,
  }) async {
    final String year = oldDevotional.startDate.year.toString();
    final String month = monthFromDateTime(oldDevotional.startDate);

    final devotionalDocumentReference = firestore
        .collection(year)
        .doc("devotional")
        .collection("devotional")
        .doc(month);

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(devotionalDocumentReference);

        //Parse Data

        Map<String, dynamic> documentData =
            snapshot.data() as Map<String, dynamic>;

        List<dynamic> devotionalList = documentData["devotional"];

        //Get the index of the old Devotional, then replace it with the new devotional
        int index = devotionalList.indexWhere(
            (element) => Devotional.fromMap(data: element) == oldDevotional);

        if(index==-1){
          throw Exception("Failed to edit message, please refresh and try again");
        }
        devotionalList[index] = newDevotional.toMap();

        ///If the month and year is the same, keep the same document reference, if not,
        ///delete the old message and place the updated message in a new ref.

        final String newYear = newDevotional.startDate.year.toString();
        final String newMonth = monthFromDateTime(newDevotional.startDate);

        if (newMonth == month && newYear == year) {
          //Now update the transaction in the new reference
          transaction.update(
              devotionalDocumentReference, {"devotional": devotionalList});
        } else {
          ///If the dates change, then delete the old devotional
          ///from the old reference, and add the updated devotional
          ///to a new reference
          await deleteDevotionalMessage(devotional: oldDevotional);
          await addDevotionalMessage(devotional: newDevotional);
        }
      },
    )
        .then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }

  Future<void> deleteDevotionalMessage({
    required Devotional devotional,
  }) async {
    final String year = devotional.startDate.year.toString();
    final String month = monthFromDateTime(devotional.startDate);

    final devotionalDocumentReference = firestore
        .collection(year)
        .doc("devotional")
        .collection("devotional")
        .doc(month);


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
        devotionalList.removeWhere(
            (element) => Devotional.fromMap(data: element) == devotional);

        //Now update the transaction
        transaction.update(
            devotionalDocumentReference, {"devotional": devotionalList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }
}
