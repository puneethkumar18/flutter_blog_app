import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';

import '../entities/user.dart';

class UserLogIn implements UseCase<User, UserLogInParams> {
  final AuthRepository authRepository;
  const UserLogIn({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserLogInParams params) async {
    return await authRepository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLogInParams {
  final String email;
  final String password;
  UserLogInParams({
    required this.email,
    required this.password,
  });
}
