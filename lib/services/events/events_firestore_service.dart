import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/event_model.dart';

class EventsFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getEvents({String? year}) async {
    ///To ensure the app will auto update when the year changes
    final String currentYear = DateTime.now().year.toString();
    final eventsDocumentReference =
    firestore.collection(year ?? currentYear).doc("events");

    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
    eventsDocumentReference.snapshots();
    return stream;
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
    )
        .then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }

  Future<void> editEvent({required Event oldEvent, required Event newEvent

  }) async {
    final String year = oldEvent.startDate.year.toString();
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

        //Get the index of the old Event, then replace it with the new Event
        int index = eventsList
            .indexWhere((element) => Event.fromMap(data: element) == oldEvent);

        if(index==-1){
          throw Exception("Failed to edit message, please refresh and try again");
        }
        eventsList[index] = newEvent.toMap();

        ///If the month and year is the same, keep the same document reference, if not,
        ///delete the old event and place the updated message in a new ref.

        final String newYear = newEvent.startDate.year.toString();

        if (newYear == year) {
          //Now update the transaction in the new reference
          transaction.update(
              eventsDocumentReference, {"events": eventsList});
        } else {
          ///If the dates change, then delete the old Event
          ///from the old reference, and add the updated Event
          ///to a new reference
          await deleteEvent(event: oldEvent);
          await addEvent(event: newEvent);
        }


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

        //Now remove the devotional
        eventsList.removeWhere((element) => Event.fromMap(data: element)==event);

        //Now update the transaction
        transaction.update(eventsDocumentReference, {"events": eventsList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
          throw Exception(e.toString());
        });
  }
}
