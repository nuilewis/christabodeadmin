import 'package:christabodeadmin/services/devotional/devotional_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../core/connection_checker/connection_checker.dart';
import '../core/errors/failure.dart';
import '../models/devotional_model.dart';

abstract class DevotionalRepository {
  Future<Either<Failure, List<Devotional>>> getDevotionals(String? year);
  Future<Either<Failure, void>> uploadDevotionalMessage(
      {required Devotional devotional});
  Future<Either<Failure, void>> editDevotionalMessage(
      {required Devotional devotional});
  Future<Either<Failure, void>> deleteDevotionalMessage(
      {required Devotional devotional});
}

class DevotionalRepositoryImplementation implements DevotionalRepository {
  final DevotionalFirestoreService devotionalFirestoreService;
  final ConnectionChecker connectionChecker;

  DevotionalRepositoryImplementation(
      {required this.devotionalFirestoreService,
      required this.connectionChecker});

  final List<Devotional> _devotionalList = [];
  final String currentYear = DateTime.now().year.toString();

  @override
  Future<Either<Failure, List<Devotional>>> getDevotionals(String? year) async {
    if (await connectionChecker.isConnected) {
      try {
        QuerySnapshot querySnapshot =
            await devotionalFirestoreService.getDevotionals(year: year);

        if (querySnapshot.docs.isNotEmpty) {
          for (DocumentSnapshot element in querySnapshot.docs) {
            Map<String, dynamic> documentData =
                element.data() as Map<String, dynamic>;

            Devotional devotional =
                Devotional.fromMap(data: documentData, docId: element.id);
            _devotionalList.add(devotional);
          }
        }
        return Right(_devotionalList);
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
  Future<Either<Failure, void>> deleteDevotionalMessage(
      {required Devotional devotional}) async {
    try {
      await devotionalFirestoreService.deleteDevotionalMessage(
          devotional: devotional);
      return Right(Future.value());
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(FirebaseFailure(
          errorMessage:
              "An unknown error occurred while trying to delete this message"));
    }
  }

  @override
  Future<Either<Failure, void>> editDevotionalMessage(
      {required Devotional devotional}) async {
    if (await connectionChecker.isConnected) {
      try {
        await devotionalFirestoreService.editDevotionalMessage(
          devotional: devotional,
        );
        return Right(Future.value());
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(FirebaseFailure(
            errorMessage:
                "An unknown error occurred while trying to edit this message"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uploadDevotionalMessage(
      {required Devotional devotional}) async {
    if (await connectionChecker.isConnected) {
      try {
        await devotionalFirestoreService.addDevotionalMessage(
          devotional: devotional,
        );
        return Right(Future.value());
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(FirebaseFailure(
            errorMessage:
                "An unknown error occurred while trying to upload this message"));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
