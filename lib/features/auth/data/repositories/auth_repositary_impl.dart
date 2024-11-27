import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/error/server_execptions.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositaryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositaryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return await _getUser(
      () async => await remoteDataSource.logInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _getUser(
      () async => await remoteDataSource.signInWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExecption catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user != null) {
        return right(user);
      }
      return left(Failure("User not logged In!"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
