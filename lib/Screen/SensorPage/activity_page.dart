import 'dart:async';

import 'package:all_sensors/all_sensors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensor_app/Provider/save_file.dart';
import 'package:simple_timer/simple_timer.dart';

class ActivityPage extends StatefulWidget {
  String activityKey, activityValue;
  ActivityPage({this.activityKey, this.activityValue});
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // TimerController _timerController;

  TimerStatus status = TimerStatus.pause;
  bool isDone = false;

  //Sensor
  List<String> _accelerometerValues;

  /* Stream for listening to sensor events*/
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    _accelerometerValues = <String>[];
    //Initialize timer controller
    // _timerController = TimerController(this);
    super.initState();
  }

  void startAccelerometerSensor(String activityValue) {
    double timeStamp = DateTime.now()
        .millisecondsSinceEpoch
        .toDouble(); //Get the current timeStamp

    //
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        timeStamp = DateTime.now().microsecondsSinceEpoch.toDouble();
        final values = <double>[
          timeStamp,
          event.x,
          event.y,
          event.z,
        ];

        print(values);

        print("Joining");
        final s =
            "Destiny Ed, ${widget.activityValue}, " + values.join(", ") + ";";
        print(s);

        // _accelerometerValues = <double>[timeStamp, event.x, event.y, event.z];
        _accelerometerValues.add(s);
      });
    }));
  }

  void stopAdSaveSensorReading(List<String> _accelerometerFinalReading) async {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }

    print("This is the accelerameter value ${_accelerometerValues.join(" ")}");

    //Request for permission here
    final status = Permission.storage;

    if (await status.isGranted) {
      SaveFile(_accelerometerFinalReading)
          .localPath()
          .then((value) => print(value));
    } else {
      status.request();
      SaveFile(_accelerometerFinalReading)
          .localPath()
          .then((value) => print(value));
    }
  }

  @override
  void dispose() {
    _accelerometerValues.clear();

    //Stop all sensor reading
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
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
          title: Text(widget.activityKey),
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
            background: Icon(Icons.switch_right_rounded),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height - 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Activity countdown for 3 Minutes
                //
                // Text("$accelerometer"),
                Container(
                  width: 250,
                  height: 250,
                  child: SimpleTimer(
                      onStart: () {
                        startAccelerometerSensor(widget.activityValue);
                        //Call Sensor Method Here
                      },
                      onEnd: () {
                        stopAdSaveSensorReading(_accelerometerValues);
                        setState(() {
                          isDone = true;
                        });
                      },
                      progressIndicatorColor: Colors.blue,
                      strokeWidth: 20.0,
                      // controller: _timerController,
                      status: status,
                      duration: Duration(seconds: 5)),
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
}
