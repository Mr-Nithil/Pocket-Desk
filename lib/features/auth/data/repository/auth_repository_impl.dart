// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:pocket_desk/core/entities/user.dart';
import 'package:pocket_desk/core/error/exception.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:pocket_desk/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockAuthDatasource mockAuthDatasource;
  AuthRepositoryImpl({required this.mockAuthDatasource});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await mockAuthDatasource.getCurrentUserData();

      if (user == null) {
        return Left(Failure("User not logged in !"));
      }

      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await mockAuthDatasource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() {
    throw UnimplementedError();
  }
}
