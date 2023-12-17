import 'package:christabodeadmin/services/firestore_service/firestore_base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/hymn_modell.dart';

class HymnFirestoreService extends FirestoreService {
  ///------------Read Operations---------------///
  Future<QuerySnapshot> getHymn() async {
    QuerySnapshot<Map<String, dynamic>> result =
        await firestore.collection("hymn").get();
    return result;
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
        if (snapshot.data()!.isNotEmpty) {
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

  Future<void> editHymn({required Hymn hymn}) async {
    //Get all Hymns first, then parse into a List of Maps, add this hymn to it, then upload. Use a Firebase transaction for that
    final hymnDocumentReference = firestore.collection("hymns").doc("hymn");

    final Map<String, dynamic> hymnData = hymn.toMap();

    firestore.runTransaction(
      (transaction) async {
        //Get Data Using transaction
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(hymnDocumentReference);

        //Parse Data
        Map<String, dynamic>? documentData =
            snapshot.data() as Map<String, dynamic>;

        List<dynamic> hymnList = documentData["hymn"];

        //Now update the hymn, can use the index
        int index =
            hymnList.indexWhere((element) => element["number"] == hymn.number);
        hymnList[index] = hymnData;

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

        List<Map<String, dynamic>>? hymnList = documentData["hymn"];

        //Now update the hymn, can use the index
        int index =
            hymnList!.indexWhere((element) => element["number"] == hymn.number);
        hymnList.removeAt(index);

        //Now update the transaction
        transaction.update(hymnDocumentReference, {"hymn": hymnList});
      },
    ).then((value) => debugPrint("Document Snapshot successfully updated"),
        onError: (e) {
      throw Exception(e.toString());
    });
  }
}
