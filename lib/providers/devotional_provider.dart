import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/errors/failure.dart';
import '../models/devotional_model.dart';
import '../repositories/devotional_repository.dart';

enum DevotionalState { initial, submitting, success, error }

class DevotionalProvider extends ChangeNotifier {
  final DevotionalRepository devotionalRepository;
  DevotionalState state = DevotionalState.initial;
  String errorMessage = "";
  List<Devotional> allDevotionals = [];

  DevotionalProvider(this.devotionalRepository);

  Future<void> getDevotional(String? year) async {
    if (state == DevotionalState.submitting) return;
    state = DevotionalState.submitting;
    notifyListeners();
    Either<Failure, List<Devotional>> response =
        await devotionalRepository.getDevotionals(year);

    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while getting today's Devotional";

      state = DevotionalState.error;
    }, (devotional) {
      allDevotionals = devotional;
      //todaysDevotional = devotional.first;
      state = DevotionalState.success;
    });
    notifyListeners();
  }

  Future<void> uploadDevotionalMessage(
      {required Devotional devotional, String? year}) async {
    if (state == DevotionalState.submitting) return;
    state = DevotionalState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .uploadDevotionalMessage(devotional: devotional, year: year);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while  trying to upload the devotional message";
      state = DevotionalState.error;
    }, (success) {
      state = DevotionalState.success;
    });
  }

  Future<void> editDevotionalMessage(
      {required Devotional devotional, String? year}) async {
    if (state == DevotionalState.submitting) return;
    state = DevotionalState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .editDevotionalMessage(devotional: devotional, year: year);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to edit the devotional message";
      state = DevotionalState.error;
    }, (success) {
      state = DevotionalState.success;
    });
  }

  Future<void> deleteDevotionalMessage(
      {required Devotional devotional, String? year}) async {
    if (state == DevotionalState.submitting) return;
    state = DevotionalState.submitting;
    notifyListeners();
    Either<Failure, void> response = await devotionalRepository
        .deleteDevotionalMessage(devotional: devotional, year: year);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to delete the devotional message";
      state = DevotionalState.error;
    }, (success) {
      state = DevotionalState.success;
    });
  }
}
