part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const AuthSignUp({
    required this.email,
    required this.name,
    required this.password,
  });
}

final class AuthLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLogIn({
    required this.email,
    required this.password,
  });
}
