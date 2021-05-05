import 'package:flutter/material.dart';
import 'package:sensor_app/Screen/splash.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey,
          ),
          primaryColor: Colors.blueGrey,
          accentColor: Colors.blueGrey),
      home: Splash(),
    );
  }
}
