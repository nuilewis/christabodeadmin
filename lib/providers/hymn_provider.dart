import 'package:christabodeadmin/repositories/hymn_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/enum/app_state.dart';
import '../core/errors/failure.dart';
import '../models/hymn_modell.dart';


class HymnnProvider extends ChangeNotifier {
  final HymnRepository hymnRepository;
  AppState state = AppState.initial;
  String errorMessage = "";
  List<Hymn> allHymns = [];
  Stream<DocumentSnapshot<Map<String, dynamic>>> dataStream = const Stream.empty();


  HymnnProvider(this.hymnRepository);

  void updateHymnList(List<Hymn> hymns) async{

    allHymns = hymns;
    //  notifyListeners();


  }

  Future<void> getHymns() async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, Stream<DocumentSnapshot<Map<String, dynamic>>>> response =
    await hymnRepository.getHymns();

    response.fold((failure) {
      errorMessage =
          failure.errorMessage ?? "An error occurred while getting the Hymn";

      state = AppState.error;
    }, (stream) {
      dataStream = stream;
    //  allHymns = hymns;
      state = AppState.success;
    });
    notifyListeners();
  }

  Future<void> uploadHymn({required Hymn hymn}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
    await hymnRepository.uploadHymn(hymn: hymn);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while  trying to upload the Hymn";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }
  Future<void> editHymn({required Hymn oldHymn, required Hymn newHymn}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
    await hymnRepository.editHymn(oldHymn: oldHymn, newHymn: newHymn);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to edit the Hymn";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> deleteHymn({required Hymn hymn}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
    await hymnRepository.deleteHymn(hymn: hymn);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to delete the Hymn";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }
}
