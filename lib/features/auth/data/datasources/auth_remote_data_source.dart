import 'package:blog_app/core/error/server_execptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signInWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<String> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<String> logInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.user == null) {
        throw const ServerExecption("User is null");
      }
      return response.user!.id;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<String> signInWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {
        'name': name,
      });

      if (response.user == null) {
        throw const ServerExecption("user is null !");
      }
      return response.user!.id;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
