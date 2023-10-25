import 'package:flutter/cupertino.dart';
import 'package:instagraam/models/user_model.dart';
import 'package:instagraam/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User get getUser => _user!;
  final AuthMethods _authMethods = AuthMethods();
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
