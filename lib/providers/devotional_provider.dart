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

  DevotionalProvider(this.devotionalRepository);

  Future<void> getDevotional(String? year) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, List<Devotional>> response =
        await devotionalRepository.getDevotionals(year);

    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while getting today's Devotional";

      state = AppState.error;
    }, (devotional) {
      allDevotionals = devotional;
      //todaysDevotional = devotional.first;
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

  Future<void> editDevotionalMessage({required Devotional devotional}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .editDevotionalMessage(devotional: devotional);
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
    }, (success) {
      state = AppState.success;
    });
    notifyListeners();
  }
}
