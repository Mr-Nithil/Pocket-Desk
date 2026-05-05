import 'package:fpdart/fpdart.dart';
import 'package:pocket_desk/core/entities/user.dart';
import 'package:pocket_desk/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> signOut();
}
