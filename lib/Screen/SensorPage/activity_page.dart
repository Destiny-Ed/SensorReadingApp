import 'dart:async';
import 'dart:convert';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:all_sensors/all_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:sensor_app/Utils/dart_to_golang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_timer/simple_timer.dart';
import 'dart:developer' as dev;
import 'package:web_socket_channel/io.dart';

class ActivityPage extends StatefulWidget {
  String activityKey, activityValue;

  ActivityPage({this.activityKey, this.activityValue});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  // TimerController _timerController;

  final activityRecognition = FlutterActivityRecognition.instance;

  ///Activity
  ActivityRecognition _activityRecognition = ActivityRecognition();

  TimerStatus status = TimerStatus.pause;
  bool isDone = false;

  //Sensor
  List<String> _accelerometerValues; //Accelerometer
  List<String> _gyroscopeValues; //GyroscopeValues

  /* Stream for listening to sensor events*/
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  String activity = "Unknown";

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://medikal-backend.herokuapp.com/ws/get-sensor-readings'));

  void _startTracking() {
    _activityRecognition
        .activityStream(runForegroundService: false)
        .listen((event) {
      setState(() {
        activity = event.type.toString();
      });
      print("============================================== $event");
      print("Calling add adding data to graphql db");
    });
  }

  @override
  void initState() {
    /*Initialize Sensor list values */
    _accelerometerValues = <String>[];
    _gyroscopeValues = <String>[];

    isPermissionGrants().then((value) {
      if (value == true) {
        _startTracking();
      }
    });

    super.initState(); // _activityStreamController.sink.add(activity);
  }

  AccelerometerEvent _accelerometerValuesAxis;

  Timer _timer;

  void startSensorAndSaveToCloudFireStore() {
    // int time = 19;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ///Send Data To Database
      Map<String, dynamic> data = {
        "time_stamp": dartToGolangDate(DateTime.now()),
        "x": _accelerometerValuesAxis.x,
        "y": _accelerometerValuesAxis.y,
        "z": _accelerometerValuesAxis.z,
        "activity": activity,
        "type": "ACCELEROMETER"
      };

      channel.sink.add(json.encode([data]));

      print(json.encode([data]));

      // ///Send data to graphql
      // runMutation(data);

      // print(data);
      // _documentReference.add(data);

      // ///Add Activity
      // _collectionReference.set({"activity": "sitting"});
    });

    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        setState(() {
          _accelerometerValuesAxis = event;
        });
      },
    );
  }

  ///Handles the accelerometer sensor
//   void startAccelerometerSensor(String activityValue) {
//     double timeStamp = DateTime.now()
//         .millisecondsSinceEpoch
//         .toDouble(); //Get the current timeStamp

//     //
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

//         //Convert the event values to comma separated and save them in a string
//         //With the following format
//         //:Userid, ActivityLabel, Values(timestamp, xAxis, yAxis, zAxis);
//         final s =
//             "$userId, ${widget.activityValue}, " + values.join(", ") + ";";
//         print(s);

//         // _accelerometerValues = <double>[timeStamp, event.x, event.y, event.z];
//         _accelerometerValues.add(s); //Add to the the _accelerometerValues
//       });
//     }));
//   }

// //Function To stop the Accelerometer and GyroScope sensor
//   void stopAdSaveSensorReading(
//       {List<String> accelerometerFinalReading,
//       List<String> gyroscopeFinalReading}) async {
//     for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
//       subscription.cancel(); //Cancel all running sensors
//     }

//     //Save Accelerormeter values and timestamps after stopping the sensor
//     SaveAccelValues(accelerometerFinalReading)
//         .localPath()
//         .then((value) => print(value));

//     //Save GyroScope Values and timestamps
//     SaveGyroValues(gyroscopeFinalReading)
//         .localPath()
//         .then((value) => print(value));
//   }

//   //Gyroscope Function : Start
//   void startGyroscopeSensor(String activityValue) {
//     double timeStamp = DateTime.now()
//         .millisecondsSinceEpoch
//         .toDouble(); //Get the current timeStamp

//     //
//     _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
//       setState(() {
//         timeStamp = DateTime.now().microsecondsSinceEpoch.toDouble();
//         final values = <double>[
//           timeStamp,
//           event.x,
//           event.y,
//           event.z,
//         ];

//         //Convert the event values to comma separated and save them in a string
//         //With the following format
//         //:Userid, ActivityLabel, Values(timestamp, xAxis, yAxis, zAxis);
//         final s =
//             "$userId, ${widget.activityValue}, " + values.join(", ") + ";";
//         print("Gyroscope $s");

//         // _accelerometerValues = <double>[timeStamp, event.x, event.y, event.z];
//         _gyroscopeValues.add(s); //Add to the the _gyroscopeValues
//       });
//     }));
//   }

  @override
  void dispose() {
    _timer.cancel();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*Arrays to save sensor events temporary*/
    // final List<String> accelerometer =
    //     _accelerometerValues?.map((String v) => v);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(widget.activityKey.toUpperCase()),
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
              // background: Icon(Icons.switch_right_rounded),
              ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height - 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return Text("Is Loading");
                    }
                  },
                ),
                Container(
                  width: 250,
                  height: 250,
                  child: SimpleTimer(
                      onStart: () async {
                        //Call Sensor Method Here
                        //Request for permission here
                        // final status = Permission.storage;

                        // if (await status.isGranted) {
                        //   startAccelerometerSensor(widget.activityValue);

                        //   startGyroscopeSensor(
                        //       widget.activityValue); //Start Reading
                        // } else {
                        //   status.request().then((value) {
                        //     //Request for permission and Start Reading if permission is granter else show error snackbar
                        //     if (value.isGranted) {
                        //       startAccelerometerSensor(widget.activityValue);

                        //       startGyroscopeSensor(widget.activityValue);
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //           content: Text(
                        //               "You must accept storage permission to perform this action"),
                        //         ),
                        //       );
                        //     }
                        //   });
                        // }
                        // startSensorAndSaveToCloudFireStore(runMutation);
                        // _timer = Timer.periodic(
                        //     const Duration(seconds: 1), (timer) {
                        //   ///Send Data To Database
                        //   Map<String, dynamic> data = {
                        //     "time_stamp":
                        //         dartToGolangDate(DateTime.now()),
                        //     "x": "${_accelerometerValuesAxis.x}",
                        //     "y": "${_accelerometerValuesAxis.y}",
                        //     "z": "${_accelerometerValuesAxis.z}",
                        //     "activity": activity,
                        //     "type": "ACCELEROMETER"
                        //   };
                        //
                        //   print(data);
                        //
                        //   ///Send data to graphql
                        //   runMutation(data);
                        //
                        //   data.clear();
                        // });

                        startSensorAndSaveToCloudFireStore();

                        accelerometerEvents.listen(
                          (AccelerometerEvent event) {
                            setState(() {
                              _accelerometerValuesAxis = event;
                            });
                          },
                        );
                      },
                      onEnd: () {
                        // stopAdSaveSensorReading(
                        //     accelerometerFinalReading: _accelerometerValues,
                        //     gyroscopeFinalReading: _gyroscopeValues);
                        setState(() {
                          isDone = true;
                        });
                      },
                      progressIndicatorColor: Colors.blue,
                      strokeWidth: 20.0,
                      // controller: _timerController,
                      status: status,
                      duration: Duration(minutes: 3)),
                ),

                //Activity start and done button
                isDone == false
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            status = TimerStatus.start;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blueGrey),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, color: Colors.white),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "START",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            status = TimerStatus.reset;
                            isDone = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blueGrey),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.white),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "DONE",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ),
        )
      ],
    ));
  }

  Future<bool> isPermissionGrants() async {
    // Check if the user has granted permission. If not, request permission.
    PermissionRequestResult reqResult;
    reqResult = await activityRecognition.checkPermission();
    if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
      dev.log('Permission is permanently denied.');
      return false;
    } else if (reqResult == PermissionRequestResult.DENIED) {
      reqResult = await activityRecognition.requestPermission();
      if (reqResult != PermissionRequestResult.GRANTED) {
        dev.log('Permission is denied.');
        return false;
      }
    }

    return true;
  }
}
