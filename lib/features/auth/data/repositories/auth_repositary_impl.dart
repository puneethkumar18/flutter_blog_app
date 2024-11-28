import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/error/server_execptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositaryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositaryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );
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
      if (!await connectionChecker.isConnected) {
        return left(Failure("No InterNet Connection"));
      }
      final user = await fn();
      return right(user);
    } on ServerExecption catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('User not Logged In!'));
        }
        return right(
          UserModel(
              id: session.user.id, email: session.user.email ?? '', name: ''),
        );
      }
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
