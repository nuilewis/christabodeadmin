import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/enum/app_state.dart';
import '../core/errors/failure.dart';
import '../models/event_model.dart';
import '../repositories/events_repository.dart';



class EventProvider extends ChangeNotifier {
  final EventsRepository eventsRepository;
  AppState state = AppState.initial;
  String errorMessage = "";
  List<Event> allEvents = [];

  EventProvider(this.eventsRepository);

  Future<void> getEvents(String? year) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, List<Event>> response =
        await eventsRepository.getEvents(year);

    response.fold((failure) {
      errorMessage =
          failure.errorMessage ?? "An error occurred while getting the events";

      state = AppState.error;
    }, (events) {
      allEvents = events;
      state = AppState.success;
    });
    notifyListeners();
  }

  Future<void> uploadEvent({required Event event}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await eventsRepository.uploadEvent(event: event);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while  trying to upload this event";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> editEvent({required Event event}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await eventsRepository.editEvent(event: event);

    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to edit the event";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });

    notifyListeners();
  }

  Future<void> deleteEvent({required Event event}) async {
    if (state == AppState.submitting) return;
    state = AppState.submitting;
    notifyListeners();
    Either<Failure, void> response =
        await eventsRepository.deleteEvent(event: event);
    response.fold((failure) {
      errorMessage = failure.errorMessage ??
          "An error occurred while trying to delete the event";
      state = AppState.error;
    }, (success) {
      state = AppState.success;
    });
    notifyListeners();
  }
}
