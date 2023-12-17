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

  PrayerProvider(this.prayerRepository);

  Future<void> getPrayers() async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, List<Prayer>> response =
        await prayerRepository.getPrayers();

    response.fold((failure) {
      errorMessage =
          failure.errorMessage ?? "An error occurred while getting the prayers";

      state = AppState.error;
    }, (prayers) {
      allPrayers = prayers;
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

  Future<void> editPrayer({required Prayer prayer}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.editPrayer(prayer: prayer);
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
