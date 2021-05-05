import 'package:flutter/material.dart';
import 'package:sensor_app/Screen/AuthScreen/register.dart';
import 'package:sensor_app/Screen/SensorPage/home.dart';
import 'package:sensor_app/Utils/page_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SensorPage/magneto_meter.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    //
    Future.delayed(const Duration(seconds: 2), () async {
      final loggedIn = await _pref;

      final name = loggedIn.getString("userName");

      if (loggedIn.getBool("loggedIn") == true) {
        PageRouter(ctx: context).nextPageAndRemove(page: Home(name));
        // PageRouter(ctx: context).nextPageAndRemove(page: Magneto());
      } else {
        PageRouter(ctx: context).nextPageAndRemove(page: RegisterPage());
      }
    });
    //
    return Scaffold(
      body: Center(
        child: Text("Sensor Application"),
      ),
    );
  }
}
