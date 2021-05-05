import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  ///Login User using shared preference
  ///
  Future<String> loginUser({String email, String password}) async {
    final SharedPreferences response = await _pref;

    final existingEmail = response.getString("emailLogin");
    final existingPassword = response.getString("passwordLogin");

    if (existingEmail == email && existingPassword == password) {
      return "Welcome Back";
    } else {
      return "Incorrect credential provided";
    }
  }

  ///Create New User
  ///
  Future<String> createUser(
      {String userName,
      String email,
      String phone,
      String weight,
      String height,
      String password}) async {
    final SharedPreferences req = await _pref;
    await req.setString("userName", userName);
    await req.setString("email", email);
    await req.setString("phone", phone);
    await req.setString("weight", weight);
    await req.setString("height", height);
    await req.setString("password", password);

    //Save User Id
    Random random = Random();
    final id = random.nextInt(10000);
    await req.setInt("userId", id);

    await req.setBool("loggedIn", true); //Store User Login

    final name = req.getString("userName");

    return name;
  }
}
