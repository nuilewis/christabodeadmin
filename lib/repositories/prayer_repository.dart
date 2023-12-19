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

  final String currentYear = DateTime.now().year.toString();

   
  Future<Either<Failure, Stream<QuerySnapshot<Map<String, dynamic>>>>> getPrayers() async {
    if (await connectionChecker.isConnected) {
      try {
        Stream<QuerySnapshot<Map<String, dynamic>>>  querySnapshot = await prayerFirestoreService.getPrayers();

        // if (querySnapshot.docs.isNotEmpty) {
        //   for (DocumentSnapshot element in querySnapshot.docs) {
        //     Map<String, dynamic> documentData =
        //         element.data() as Map<String, dynamic>;
        //
        //     Prayer prayer =
        //         Prayer.fromMap(data: documentData, docId: element.id);
        //     _prayerList.add(prayer);
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

   
  Future<Either<Failure, void>> editPrayer({required Prayer oldPrayer, required Prayer newPrayer}) async {
    if (await connectionChecker.isConnected) {
      try {
        await prayerFirestoreService.editPrayer(oldPrayer: oldPrayer, newPrayer:  newPrayer);
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
