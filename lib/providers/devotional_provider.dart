import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/enum/app_state.dart';
import '../core/errors/failure.dart';
import '../models/devotional_model.dart';
import '../repositories/devotional_repository.dart';


class DevotionalProvider extends ChangeNotifier {
  final DevotionalRepository devotionalRepository;
  AppState state = AppState.initial;
  String errorMessage = "";
  List<Devotional> allDevotionals = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> dataStream = const Stream.empty();



  DevotionalProvider(this.devotionalRepository);

  void updateDevotionalList(List<Devotional> devotionals) async{

    allDevotionals = devotionals;
  //  notifyListeners();


  }







  Future<void> getDevotional(String? year) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>> response =
        await devotionalRepository.getDevotionals(year);

    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while getting today's Devotional";

      state = AppState.error;
    }, (stream) {
      dataStream = stream;
      state = AppState.success;
    });
    notifyListeners();
  }

  Future<void> uploadDevotionalMessage({required Devotional devotional}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .uploadDevotionalMessage(devotional: devotional);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while  trying to upload the devotional message";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> editDevotionalMessage({required Devotional newDevotional, required Devotional oldDevotional}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .editDevotionalMessage(oldDevotional: oldDevotional, newDevotional:  newDevotional);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to edit the devotional message";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> deleteDevotionalMessage({required Devotional devotional}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .deleteDevotionalMessage(devotional: devotional);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to delete the devotional message";
      state = AppState.error;
    }, (success) async {

      state = AppState.success;

    });
    notifyListeners();
  }
}
