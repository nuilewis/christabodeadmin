import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/errors/failure.dart';
import '../models/prayer_model.dart';
import '../repositories/prayer_repository.dart';

enum PrayerState { initial, submitting, success, error }

class PrayerProvider extends ChangeNotifier {
  final PrayerRepository prayerRepository;
  PrayerState state = PrayerState.initial;
  String errorMessage = "";
  List<Prayer> allPrayers = [];

  PrayerProvider(this.prayerRepository);

  Future<void> getPrayers() async {
    if (state == PrayerState.submitting) return;
    state = PrayerState.submitting;
    notifyListeners();
    Either<Failure, List<Prayer>> response =
        await prayerRepository.getPrayers();

    response.fold((failure) {
      errorMessage =
          failure.errorMessage ?? "An error occurred while getting the prayers";

      state = PrayerState.error;
    }, (prayers) {
      allPrayers = prayers;
      state = PrayerState.success;
    });
    notifyListeners();
  }

  Future<void> uploadPrayer({required Prayer prayer}) async {
    if (state == PrayerState.submitting) return;
    state = PrayerState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.uploadPrayer(prayer: prayer);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while  trying to upload the prayer";
      state = PrayerState.error;
    }, (success) {
      state = PrayerState.success;
    });

    notifyListeners();
  }

  Future<void> editPrayer({required Prayer prayer}) async {
    if (state == PrayerState.submitting) return;
    state = PrayerState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.editPrayer(prayer: prayer);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to edit the prayer";
      state = PrayerState.error;
    }, (success) {
      state = PrayerState.success;
    });

    notifyListeners();
  }

  Future<void> deletePrayer({required Prayer prayer}) async {
    if (state == PrayerState.submitting) return;
    state = PrayerState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await prayerRepository.deletePrayer(prayer: prayer);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to delete the prayer";
      state = PrayerState.error;
    }, (success) {
      state = PrayerState.success;
    });

    notifyListeners();
  }
}
