import 'package:fpdart/fpdart.dart';
import 'package:pocket_desk/core/entities/user.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/auth/domain/repository/auth_repository.dart';

class UserStatusCheck implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  UserStatusCheck({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}
