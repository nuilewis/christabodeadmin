import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    final Map<String, dynamic> eventData = event.toMap();
    final String year = event.startDate.year.toString();
    final eventsDocumentReference = firestore.collection(year).doc("events");

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(eventsDocumentReference);

        //Parse Data
        if (snapshot.exists) {
          Map<String, dynamic> documentData =
              snapshot.data() as Map<String, dynamic>;

          List<dynamic> eventsList = documentData["events"];

          //now Add the new Event to the List
          eventsList.add(eventData);

          //Now update the transaction
          transaction.update(eventsDocumentReference, {"events": eventsList});
        } else {
          //Case where there is no pre existing data
          transaction.set(
            eventsDocumentReference,
            {
              "events": [eventData]
            },
          );
        }
      },
    );
    //     .then((value) => debugPrint("Document Snapshot successfully updated"),
    //     onError: (e) {
    //   throw Exception(e.toString());
    // });
  }

  Future<void> editEvent({required Event event}) async {
    final Map<String, dynamic> eventData = event.toMap();
    final String year = event.startDate.year.toString();
    final eventsDocumentReference = firestore.collection(year).doc("events");

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(eventsDocumentReference);

        //Parse Data

        Map<String, dynamic> documentData =
            snapshot.data() as Map<String, dynamic>;

        List<dynamic> eventsList = documentData["events"];

        //Now update the Event, can use the index
        int index = eventsList
            .indexWhere((element) => element["date"] == event.startDate);
        eventsList[index] = eventData;

        //Now update the transaction
        transaction.update(eventsDocumentReference, {"events": eventsList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }

  Future<void> deleteEvent({required Event event}) async {
    final String year = event.startDate.year.toString();
    final eventsDocumentReference = firestore.collection(year).doc("events");
    firestore.runTransaction(
          (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await transaction.get(eventsDocumentReference);

        //Parse Data
        Map<String, dynamic>? documentData =
        snapshot.data() as Map<String, dynamic>;

        List<dynamic> eventsList = documentData["events"];

        //Now update the event and remove it, can use the index
        int index =
        eventsList.indexWhere((element) => element["startDate"] == event.startDate);
        eventsList.removeAt(index);

        //Now update the transaction
        transaction.update(eventsDocumentReference, {"events": eventsList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });
  }
}
