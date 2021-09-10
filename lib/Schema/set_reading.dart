String getString = """
  mutation sendReading(\$x: Float!, \$y: Float!, \$z: Float!, \$activity : String!, \$time_stamp: Time!, \$type : SensorType!) {
  sendSensorReadings(sensorType: \$type, input: {
    x: \$x,
    y: \$y,
    z: \$z,
    activity: \$activity,
    timeStamp: \$time_stamp,
  })
}
  """;
