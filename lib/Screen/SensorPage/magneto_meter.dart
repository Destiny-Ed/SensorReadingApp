// import 'dart:async';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter_magnetometer/flutter_magnetometer.dart';

// class CompassPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CompassPageState();
// }

// class _CompassPageState extends State<CompassPage> {
//   MagnetometerData _magnetometerData = MagnetometerData(0.0, 0.0, 0.0);

//   StreamSubscription _magnetometerListener;

//   /// assign listener and start setting real data over [_magnetometerData]
//   @override
//   void initState() {
//     super.initState();
//     _magnetometerListener = FlutterMagnetometer.events.listen(
//         (MagnetometerData data) => setState(() => _magnetometerData = data));
//   }

//   @override
//   void dispose() {
//     _magnetometerListener.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double atan2 = math.atan2(_magnetometerData.y, _magnetometerData.x);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Magnetometer Example'),
//       ),
//       body: ListView(
//         semanticChildCount: 3,
//         children: <Widget>[
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Transform.rotate(
//                 // calculate the direction we're heading in degrees, then convert to radian
//                 angle: math.pi / 2 - atan2,
//                 child: Image.asset('assets/compass.png'),
//               ),
//             ),
//           ),
//           Text(
//               'Raw microtesla values: \n: ${_magnetometerData.toStringDeep()}'),
//           Text('atan2 result:\n $atan2'),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensor_app/Provider/magnetorListener.dart';

import 'dart:math' as math;

class Magneto extends StatefulWidget {
  @override
  _MagnetoState createState() => _MagnetoState();
}

class _MagnetoState extends State<Magneto> {
  /* Stream for listening to sensor events*/
  StreamSubscription _streamSubscriptions;

  //Sensor
  List<double> _magnetoMeterValues;

  @override
  void initState() {
    _magnetoMeterValues = <double>[];

    _streamSubscriptions = magnetoEvent.listen(
      (MagnetoEvent event) {
        setState(() {
          _magnetoMeterValues = <double>[event.x, event.y, event.z];
        });
      },
    );

    super.initState();
  }

  ///Handles the accelerometer sensor
  void startAccelerometerSensor() {
    _streamSubscriptions = magnetoEvent.listen(
      (MagnetoEvent event) {
        setState(() {
          _magnetoMeterValues = <double>[event.x, event.y, event.z];
          print(_magnetoMeterValues);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double tan2 =
        math.atan2(_magnetoMeterValues[1], _magnetoMeterValues[0]);
    return Scaffold(
      appBar: AppBar(title: Text("Magneto")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_drop_down_outlined,
                size: 40,
              ),
            ),
            Transform.rotate(
              angle: math.pi / 2 - tan2,
              child: Image.asset("assets/compass.png"),
            ),
            Text(
                "Magnetic field values on X, Y, Z axis respectively \n $_magnetoMeterValues")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startAccelerometerSensor();
        },
      ),
    );
  }
}
