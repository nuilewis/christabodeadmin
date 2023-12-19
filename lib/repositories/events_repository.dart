import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../core/connection_checker/connection_checker.dart';
import '../core/errors/failure.dart';
import '../models/event_model.dart';
import '../services/events/events_firestore_service.dart';



class EventsRepository {
  final EventsFirestoreService eventsFirestoreService;
  final ConnectionChecker connectionChecker;

  EventsRepository(
      {required this.eventsFirestoreService,
        required this.connectionChecker});

  final String currentYear = DateTime.now().year.toString();


  Future<Either<Failure,Stream<DocumentSnapshot<Map<String, dynamic>>>>> getEvents(String? year) async {
    if (await connectionChecker.isConnected) {
      try {
        Stream<DocumentSnapshot<Map<String, dynamic>>> querySnapshot =
        await eventsFirestoreService.getEvents(year: year);

        // if (querySnapshot.docs.isNotEmpty) {
        //   for (DocumentSnapshot element in querySnapshot.docs) {
        //     Map<String, dynamic> documentData =
        //     element.data() as Map<String, dynamic>;
        //
        //     Event event =
        //     Event.fromMap(data: documentData, docId: element.id);
        //     _eventsList.add(event);
        //   }
        // }
        return Right(querySnapshot);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(
            Failure(errorMessage: "An unknown error has occurred"));
      }
    } else {
      return const Left(Failure.network());
    }
  }


  Future<Either<Failure, void>> deleteEvent(
      {required Event event}) async {
    try {
      await eventsFirestoreService.deleteEvent(
          event: event);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(Failure(
          errorMessage:
          "An unknown error occurred while trying to delete this event"));
    }
  }


  Future<Either<Failure, void>> editEvent(
      {required Event oldEvent, required Event newEvent}) async {
    if (await connectionChecker.isConnected) {
      try {
        await eventsFirestoreService.editEvent(
          oldEvent:  oldEvent,
          newEvent: newEvent,
        );
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
            "An unknown error occurred while trying to edit this event"));
      }
    } else {
      return const Left(Failure.network());
    }
  }

  Future<Either<Failure, void>> uploadEvent(
      {required Event event}) async {
    if (await connectionChecker.isConnected) {
      try {
        await eventsFirestoreService.addEvent(
        event: event,
        );
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
            "An unknown error occurred while trying to upload this event"));
      }
    } else {
      return const Left(Failure.network());
    }
  }
}
