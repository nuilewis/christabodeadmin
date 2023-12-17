import 'package:christabodeadmin/services/hymn/hymn_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../core/connection_checker/connection_checker.dart';
import '../core/errors/failure.dart';
import '../models/hymn_modell.dart';


class HymnRepository {
  final HymnFirestoreService hymnFirestoreService;
  final ConnectionChecker connectionChecker;

  HymnRepository(
      {required this.hymnFirestoreService, required this.connectionChecker});

  final List<Hymn> _hymnList = [];
  final String currentYear = DateTime.now().year.toString();


  Future<Either<Failure, List<Hymn>>> getHymns() async {
    if (await connectionChecker.isConnected) {
      try {
        QuerySnapshot querySnapshot = await hymnFirestoreService.getHymn();

        if (querySnapshot.docs.isNotEmpty) {
          for (DocumentSnapshot element in querySnapshot.docs) {
            Map<String, dynamic> documentData =
            element.data() as Map<String, dynamic>;

            Hymn hymn =
            Hymn.fromMap(data: documentData, docId: element.id);
            _hymnList.add(hymn);
          }
        }
        return Right(_hymnList);
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


  Future<Either<Failure, void>> deleteHymn({required Hymn hymn}) async {
    try {
      await hymnFirestoreService.deleteHymn(hymn: hymn);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure(errorMessage: e.message, code: e.code));
    } catch (e) {
      return const Left(Failure(
          errorMessage:
          "An unknown error occurred while trying to delete this Hymn"));
    }
  }


  Future<Either<Failure, void>> editHymn({required Hymn hymn}) async {
    if (await connectionChecker.isConnected) {
      try {
        await hymnFirestoreService.editHymn(hymn: hymn);
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        return const Left(Failure(
            errorMessage:
            "An unknown error occurred while trying to edit this Hymn"));
      }
    } else {
      return const Left(Failure.network());
    }
  }


  Future<Either<Failure, void>> uploadHymn({required Hymn hymn}) async {
    if (await connectionChecker.isConnected) {
      try {
        await hymnFirestoreService.addHymn(hymn: hymn);
        return const Right(null);
      } on FirebaseException catch (e) {
        print("firebase exception caguth");
        return Left(Failure(errorMessage: e.message, code: e.code));
      } catch (e) {
        print("general exception caught");
        return const Left(Failure(
            errorMessage:
            "An unknown error occurred while trying to upload this Hymn"));
      }
    } else {
      return const Left(Failure.network());
    }
  }
}
