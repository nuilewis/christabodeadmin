import 'package:christabodeadmin/services/devotional/devotional_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../core/connection_checker/connection_checker.dart';
import '../core/errors/failure.dart';
import '../models/devotional_model.dart';



class DevotionalRepository{
  final DevotionalFirestoreService devotionalFirestoreService;
  final ConnectionChecker connectionChecker;

  DevotionalRepository(
      {required this.devotionalFirestoreService,
      required this.connectionChecker});

  final String currentYear = DateTime.now().year.toString();


  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getDevotionals(String? year) async {
    if (await connectionChecker.isConnected) {
      try {
        Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
            await devotionalFirestoreService.getDevotionals(year: year);

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


  Future<Either<Failure, void>> deleteDevotionalMessage(
      {required Devotional devotional}) async {
    try {
      await devotionalFirestoreService.deleteDevotionalMessage(
          devotional: devotional);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(Failure(
          errorMessage:
              "An unknown error occurred while trying to delete this message"));
    }
  }


  Future<Either<Failure, void>> editDevotionalMessage(
      {required Devotional oldDevotional, required Devotional newDevotional}) async {
    if (await connectionChecker.isConnected) {
      try {
        await devotionalFirestoreService.editDevotionalMessage(
          oldDevotional: oldDevotional,
          newDevotional: newDevotional,
        );
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
                "An unknown error occurred while trying to edit this message"));
      }
    } else {
      return const Left(Failure.network());
    }
  }

  Future<Either<Failure, void>> uploadDevotionalMessage(
      {required Devotional devotional}) async {
    if (await connectionChecker.isConnected) {
      try {
        await devotionalFirestoreService.addDevotionalMessage(
          devotional: devotional,
        );
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
                "An unknown error occurred while trying to upload this message"));
      }
    } else {
      return const Left(Failure.network());
    }
  }
}
