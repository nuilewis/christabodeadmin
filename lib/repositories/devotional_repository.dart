import 'package:christabodeadmin/services/devotional/devotional_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../core/errors/failure.dart';
import '../models/devotional_model.dart';

abstract class DevotionalRepository {
  Future<Either<Failure, List<Devotional>>> getDevotionals(String? year);
  Future<Either<Failure, void>> uploadDevotionalMessage(
      {required Devotional devotional, String? year});
  Future<Either<Failure, void>> editDevotionalMessage(
      {required Devotional devotional, String? year});
  Future<Either<Failure, void>> deleteDevotionalMessage(
      {required Devotional devotional, String? year});
}

class DevotionalRepositoryImplementation implements DevotionalRepository {
  final DevotionalFirestoreService devotionalFirestoreService;

  DevotionalRepositoryImplementation(
      {required this.devotionalFirestoreService});

  ///Todo: maybe add conenction checker

  List<Devotional> _devotionalList = [];
  final String currentYear = DateTime.now().year.toString();

  @override
  Future<Either<Failure, List<Devotional>>> getDevotionals(String? year) async {
    try {
      QuerySnapshot querySnapshot =
          await devotionalFirestoreService.getDevotionals();

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
    }
  }

  @override
  Future<Either<Failure, void>> deleteDevotionalMessage(
      {required Devotional devotional, String? year}) async {
    try {
      await devotionalFirestoreService.deleteDevotionalMessage(
          year: year ?? currentYear, devotional: devotional);
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
      {required Devotional devotional, String? year}) async {
    try {
      await devotionalFirestoreService.editDevotionalMessage(
          devotional: devotional, year: year ?? currentYear);
      return Right(Future.value());
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(FirebaseFailure(
          errorMessage:
              "An unknown error occurred while trying to edit this message"));
    }
  }

  @override
  Future<Either<Failure, void>> uploadDevotionalMessage(
      {required Devotional devotional, String? year}) async {
    try {
      await devotionalFirestoreService.addDevotionalMessage(
          devotional: devotional, year: year ?? currentYear);
      return Right(Future.value());
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(FirebaseFailure(
          errorMessage:
              "An unknown error occurred while trying to upload this message"));
    }
  }
}