import 'package:flutter/material.dart';

import 'Screen/SensorPage/home.dart';
import 'Screen/SensorPage/sensor_home.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey,
          ),
          primaryColor: Colors.blueGrey,
          accentColor: Colors.blueGrey),
      home: Home(),
    );
  }
}
