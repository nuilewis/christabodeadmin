import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/enum/app_state.dart';
import '../core/errors/failure.dart';
import '../models/prayer_model.dart';
import '../repositories/prayer_repository.dart';



class PrayerProvider extends ChangeNotifier {
  final PrayerRepository prayerRepository;
  AppState state = AppState.initial;
  String errorMessage = "";
  List<Prayer> allPrayers = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> dataStream = const Stream.empty();


  PrayerProvider(this.prayerRepository);
  void updateDPrayerList(List<Prayer> prayers) async{

    allPrayers = prayers;
    //  notifyListeners();


  }

  Future<void> getPrayers() async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>> response =
        await prayerRepository.getPrayers();

    response.fold((failure) {
      errorMessage =
          failure.errorMessage ?? "An error occurred while getting the prayers";

      state = AppState.error;
    }, (stream) {
      dataStream = stream;
      state = AppState.success;
    });
    notifyListeners();
  }

  Future<void> uploadPrayer({required Prayer prayer}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.uploadPrayer(prayer: prayer);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while  trying to upload the prayer";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> editPrayer({required Prayer oldPrayer, required Prayer newPrayer}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.editPrayer(oldPrayer: oldPrayer, newPrayer: newPrayer);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to edit the prayer";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> deletePrayer({required Prayer prayer}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.deletePrayer(prayer: prayer);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to delete the prayer";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }
}
