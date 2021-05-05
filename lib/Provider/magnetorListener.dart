import 'package:flutter/services.dart';

const EventChannel platform = EventChannel('com.destiny_ed/magnetic_field');

// const platform = const MethodChannel("MAG.SSS");

class MagnetoEvent {
  /// Magnetic force along the x axis (including gravity) measured in m/s^2.
  final double x;

  /// Magnetic force along the y axis (including gravity) measured in m/s^2.
  final double y;

  /// Magnetic force along the z axis (including gravity) measured in m/s^2.
  final double z;

  double getZ() => this.z;

  MagnetoEvent(this.x, this.y, this.z);

  @override
  String toString() => '[MagnetoEvent (x: $x, y: $y, z: $z)]';
}

MagnetoEvent _listToMagnetoEvent(List<double> list) {
  return MagnetoEvent(list[0], list[1], list[2]);
}

Stream<MagnetoEvent> _magnetoEvents;

/// A broadcast stream of events from the device magnetometer.
Stream<MagnetoEvent> get magnetoEvent {
  if (_magnetoEvents == null) {
    _magnetoEvents = platform
        .receiveBroadcastStream()
        .map((dynamic event) => _listToMagnetoEvent(event.cast<double>()));
  }
  return _magnetoEvents;
}
