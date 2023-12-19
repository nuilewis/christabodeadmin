import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/hymn_modell.dart';

class HymnFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>>  getHymn() async {

    final hymnDocumentReference =
    firestore.collection("hymn").doc("hymn");

    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
    hymnDocumentReference.snapshots();
    return stream;
  }

  ///-------------Write Operations-------------///
  Future<void> addHymn({required Hymn hymn}) async {
    //Get all Hymns first, then parse into a List of Maps, add this hymn to it, then upload. Use a Firebase transaction for that
    final hymnDocumentReference = firestore.collection("hymn").doc("hymn");

    final Map<String, dynamic> hymnData = hymn.toMap();

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(hymnDocumentReference);

        //Parse Data
        if (snapshot.exists) {
          Map<String, dynamic> documentData =
              snapshot.data() as Map<String, dynamic>;

          List<dynamic> hymnList = documentData["hymn"];

          //now Add the new Hymn to the List
          hymnList.add(hymnData);

          //Now update the transaction
          transaction.update(hymnDocumentReference, {"hymn": hymnList});
        } else {
          //Case where there is no pre existing data
          transaction.set(
            hymnDocumentReference,
            {
              "hymn": [hymnData]
            },
          );
        }
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }

  Future<void> editHymn({required Hymn oldHymn, required Hymn newHymn}) async {
    //Get all Hymns first, then parse into a List of Maps, add this hymn to it, then upload. Use a Firebase transaction for that
    final hymnDocumentReference = firestore.collection("hymn").doc("hymn");

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(hymnDocumentReference);

        //Parse Data
        Map<String, dynamic> documentData =
            snapshot.data() as Map<String, dynamic>;

        List<dynamic> hymnList = documentData["hymn"];

        //Get the index of the old Hymn, then replace it with the new Hymn

        int index =
            hymnList.indexWhere((element) => Hymn.fromMap(data: element) == oldHymn);
        if(index==-1){
          throw Exception("Failed to edit message, please refresh and try again");
        }

        hymnList[index] = newHymn.toMap();

        //Now update the transaction
        transaction.update(hymnDocumentReference, {"hymn": hymnList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }

  Future<void> deleteHymn({required Hymn hymn}) async {
    //Get all Hymns first, then parse into a List of Maps, add this hymn to it, then upload. Use a Firebase transaction for that
    final hymnDocumentReference = firestore.collection("hymn").doc("hymn");

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(hymnDocumentReference);

        //Parse Data
        Map<String, dynamic>? documentData =
            snapshot.data() as Map<String, dynamic>;

        List<dynamic> hymnList = documentData["hymn"];

        //Now Remove the Hymn

        hymnList.removeWhere((element) => Hymn.fromMap(data: element)==hymn);

        //Now update the transaction
        transaction.update(hymnDocumentReference, {"hymn": hymnList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }
}
