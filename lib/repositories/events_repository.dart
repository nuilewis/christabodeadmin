import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../core/connection_checker/connection_checker.dart';
import '../core/errors/failure.dart';
import '../models/event_model.dart';
import '../services/events/events_firestore_service.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<Event>>> getEvents(String? year);
  Future<Either<Failure, void>> uploadEvent(
      {required Event event});
  Future<Either<Failure, void>> editEvent(
      {required Event event});
  Future<Either<Failure, void>> deleteEvent(
      {required Event event});
}

class EventsRepositoryImplementation implements EventsRepository {
  final EventsFirestoreService eventsFirestoreService;
  final ConnectionChecker connectionChecker;

  EventsRepositoryImplementation(
      {required this.eventsFirestoreService,
        required this.connectionChecker});

  final List<Event> _eventsList = [];
  final String currentYear = DateTime.now().year.toString();

  @override
  Future<Either<Failure, List<Event>>> getEvents(String? year) async {
    if (await connectionChecker.isConnected) {
      try {
        QuerySnapshot querySnapshot =
        await eventsFirestoreService.getEvents(year: year);


        if (querySnapshot.docs.isNotEmpty) {
          for (DocumentSnapshot element in querySnapshot.docs) {
            Map<String, dynamic> documentData =
            element.data() as Map<String, dynamic>;

            Event event =
            Event.fromMap(data: documentData, docId: element.id);
            _eventsList.add(event);
          }
        }
        return Right(_eventsList);
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(
            FirebaseFailure(errorMessage: "An unknown error has occurred"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(
      {required Event event}) async {
    try {
      await eventsFirestoreService.deleteEvent(
          event: event);
      return Right(Future.value());
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(FirebaseFailure(
          errorMessage:
          "An unknown error occurred while trying to delete this event"));
    }
  }

  @override
  Future<Either<Failure, void>> editEvent(
      {required Event event}) async {
    if (await connectionChecker.isConnected) {
      try {
        await eventsFirestoreService.editEvent(
          event: event,
        );
        return Right(Future.value());
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(FirebaseFailure(
            errorMessage:
            "An unknown error occurred while trying to edit this event"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uploadEvent(
      {required Event event}) async {
    if (await connectionChecker.isConnected) {
      try {
        await eventsFirestoreService.addEvent(
        event: event,
        );
        return Right(Future.value());
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(FirebaseFailure(
            errorMessage:
            "An unknown error occurred while trying to upload this event"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
