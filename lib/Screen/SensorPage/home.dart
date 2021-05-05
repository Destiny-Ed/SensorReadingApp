import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sensor_app/Screen/SensorPage/activity_page.dart';
import 'package:sensor_app/Screen/SensorPage/magneto_meter.dart';
import 'package:sensor_app/Screen/SensorPage/sensor_home.dart';
import 'package:sensor_app/Utils/page_router.dart';

class Home extends StatefulWidget {
  final String name;
  Home(this.name);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: "SENSOR ", style: TextStyle(color: Colors.blue)),
                  TextSpan(text: "READING")
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "${widget.name} Start With An Activity",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                ...List.generate(activity.length, (index) {
                  String activityKey = activity.keys.elementAt(index);
                  String activityValues = activity.values.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      PageRouter(ctx: context).nexPage(
                          page: ActivityPage(
                              activityKey: activityKey,
                              activityValue: activityValues));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            activityKey.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black26),
                    ),
                  );
                })
              ],
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text("Compass"),
          onPressed: () {
            PageRouter(ctx: context).nexPage(page: Magneto());
          }),
    );
  }

  Map<String, String> activity = {
    "walking": "A",
    "jogging": "B",
    "stairs": "C",
    "sitting": "D",
    "standing": "E"
  };
}
