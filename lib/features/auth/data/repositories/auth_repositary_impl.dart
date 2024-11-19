import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/error/server_execptions.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositaryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositaryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, String>> logInWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final userId = await authRemoteDataSource.signInWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(userId);
    } on ServerExecption catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
