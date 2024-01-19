import 'package:flutter/foundation.dart';
import 'package:instagramclone/resources/auth_method.dart';
import 'package:instagramclone/resources/user.dart';

class UserProvider with ChangeNotifier{
  UserClass? _user;
  final AuthMethod _authMethod = AuthMethod();

  // UserClass get getUser => _user!;

  UserClass get getUser {
    if (_user != null) {
      return _user!;
    } else {
      throw Exception("User is null");
    }
  }

  Future<void> refreshUser() async{
    UserClass user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners(); 
  }
}