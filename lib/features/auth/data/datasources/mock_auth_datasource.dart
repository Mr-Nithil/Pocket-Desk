import 'package:pocket_desk/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pocket_desk/features/auth/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class MockAuthDatasource {
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();
}

class MockAuthDataSourceImpl implements MockAuthDatasource {
  final SharedPreferences sharedPreferences;

  MockAuthDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCurrentUserData() {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = UserModel(email: email, name: "Mock User");

      await sharedPreferences.setBool('is_logged_in', true);
      await sharedPreferences.setString('user_email', user.email);
      await sharedPreferences.setString('user_name', user.name);

      print("-------------");
      print(sharedPreferences.getBool('is_logged_in'));
      print(sharedPreferences.getString('user_email'));
      print(sharedPreferences.getString('user_name'));

      return user;
    } catch (e) {
      throw ServerException("Login failed: ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}
