import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../core/connection_checker/connection_checker.dart';
import '../core/errors/failure.dart';
import '../models/prayer_model.dart';
import '../services/prayer/prayer_firestore_service.dart';


class PrayerRepository {
  final PrayerFirestoreService prayerFirestoreService;
  final ConnectionChecker connectionChecker;

  PrayerRepository(
      {required this.prayerFirestoreService, required this.connectionChecker});

  final List<Prayer> _prayerList = [];
  final String currentYear = DateTime.now().year.toString();

   
  Future<Either<Failure, List<Prayer>>> getPrayers() async {
    if (await connectionChecker.isConnected) {
      try {
        QuerySnapshot querySnapshot = await prayerFirestoreService.getPrayers();

        if (querySnapshot.docs.isNotEmpty) {
          for (DocumentSnapshot element in querySnapshot.docs) {
            Map<String, dynamic> documentData =
                element.data() as Map<String, dynamic>;

            Prayer prayer =
                Prayer.fromMap(data: documentData, docId: element.id);
            _prayerList.add(prayer);
          }
        }
        return Right(_prayerList);
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

   
  Future<Either<Failure, void>> deletePrayer({required Prayer prayer}) async {
    try {
      await prayerFirestoreService.deletePrayer(prayer: prayer);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(Failure(
          errorMessage:
              "An unknown error occurred while trying to delete this prayer"));
    }
  }

   
  Future<Either<Failure, void>> editPrayer({required Prayer prayer}) async {
    if (await connectionChecker.isConnected) {
      try {
        await prayerFirestoreService.editPrayer(prayer: prayer);
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
                "An unknown error occurred while trying to edit this prayer"));
      }
    } else {
      return const Left(Failure.network());
    }
  }

   
  Future<Either<Failure, void>> uploadPrayer({required Prayer prayer}) async {
    if (await connectionChecker.isConnected) {
      try {
        await prayerFirestoreService.addPrayer(prayer: prayer);
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
                "An unknown error occurred while trying to upload this prayer"));
      }
    } else {
      return const Left(Failure.network());
    }
  }
}
