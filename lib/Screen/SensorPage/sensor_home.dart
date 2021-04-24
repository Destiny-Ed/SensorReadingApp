// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:all_sensors/all_sensors.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sensor_app/Provider/save_file.dart';

// class SensorHome extends StatefulWidget {
//   String activityValue;
//   SensorHome({this.activityValue, Key key}) : super(key: key);

//   @override
//   _SensorHomeState createState() => _SensorHomeState();
// }

// class _SensorHomeState extends State<SensorHome> {
//   List<double> _accelerometerValues;
//   List<double> _userAccelerometerValues;
//   List<double> _gyroscopeValues;
//   bool _proximityValues = false;

//   /* Stream for listening to sensor events*/
//   List<StreamSubscription<dynamic>> _streamSubscriptions =
//       <StreamSubscription<dynamic>>[];

//   @override
//   Widget build(BuildContext context) {
//     /*Arrays to save sensor events temporary*/
//     final List<String> accelerometer =
//         _accelerometerValues?.map((double v) => v.toStringAsFixed(4))?.toList();
//     final List<String> gyroscope =
//         _gyroscopeValues?.map((double v) => v.toStringAsFixed(4))?.toList();
//     final List<String> userAccelerometer = _userAccelerometerValues
//         ?.map((double v) => v.toStringAsFixed(8))
//         ?.toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sensor Example'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Padding(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Accelerometer: $accelerometer'),
//               ],
//             ),
//             padding: const EdgeInsets.all(16.0),
//           ),
//           Padding(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('UserAccelerometer: $userAccelerometer'),
//               ],
//             ),
//             padding: const EdgeInsets.all(16.0),
//           ),
//           // Padding(
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //     children: <Widget>[
//           //       Text('Gyroscope: $gyroscope'),
//           //     ],
//           //   ),
//           //   padding: const EdgeInsets.all(16.0),
//           // ),
//           Padding(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Text('Proximity: $_proximityValues'),
//                 _proximityValues == false
//                     ? Container()
//                     : Text("Don't touch the top of your screen")
//               ],
//             ),
//             padding: const EdgeInsets.all(16.0),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           startSensors(Duration(seconds: 10));
//         },
//         label: Text("Start Activity"),
//       ),
//     );
//   }

//   void startSensors(Duration duration) {
//     double timeStamp = DateTime.now().millisecondsSinceEpoch.toDouble();
//     _streamSubscriptions
//         .add(accelerometerEvents.listen((AccelerometerEvent event) {
//       setState(() {
//         timeStamp = DateTime.now().microsecondsSinceEpoch.toDouble();
//         final values = <double>[
//           timeStamp,
//           event.x,
//           event.y,
//           event.z,
//         ];
//         // _accelerometerValues = <double>[timeStamp, event.x, event.y, event.z];
//         _accelerometerValues .addAll(values);
//       });
//     }));

//     // _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
//     //   setState(() {
//     //     _gyroscopeValues = <double>[event.x, event.y, event.z];
//     //   });
//     // }));

//     // _streamSubscriptions
//     //     .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
//     //   setState(() {
//     //     _userAccelerometerValues = <double>[event.x, event.y, event.z];
//     //   });
//     // }));
//     // _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
//     //   setState(() {
//     //     _proximityValues = event.getValue();
//     //   });
//     // }));

//     Future.delayed(duration, () async {
//       for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
//         subscription.cancel();
//       }

//       print("This is the accelerameter value $_accelerometerValues");

//       //Request for permission here
//       final status = Permission.storage;

//       if (await status.isGranted) {
//         SaveFile(_accelerometerValues)
//             .localPath()
//             .then((value) => print(value));
//       } else {
//         status.request();
//         SaveFile(_accelerometerValues)
//             .localPath()
//             .then((value) => print(value));
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     startSensors(Duration(seconds: 40));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
//       subscription.cancel();
//     }
//   }
// }
