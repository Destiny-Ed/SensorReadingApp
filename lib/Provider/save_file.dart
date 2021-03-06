import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

//Class to Handle the saving of Accelerometer values to Phone Storage
class SaveAccelValues {
  List<String> accelerometerSensors;
  SaveAccelValues(this.accelerometerSensors);

  Future<String> localPath() async {
    Directory directory = await getExternalStorageDirectory();

    List<String> path = directory.path.split("/");

    String storepath = "";

    ///storage/emulated/0/Android/data/app.sensor/files

    for (int i = 1; i < path.length; i++) {
      String folder = path[i];

      if (folder != "Android") {
        storepath += "/" + folder;
      } else {
        print("StorePath " + storepath);
        break;
      }
    }

    storepath = storepath + "/SensorApp";
    //Update the directory path to the new path
    directory = Directory(storepath + "/Accel_reading");
    print(directory);

    if (!await directory.exists()) {
      await directory.create(recursive: true); /*Create New Directory */
    }

    /**Get Format Date */
    String fDate = DateFormat().format(DateTime.now());
    if (await directory.exists()) {
      //Save File
      final File file = File("${directory.path}/$fDate.txt");

      //Conver the accelerometerSensor value from List to string before saving
      final accelerometerSensorValue = accelerometerSensors.join(" ");

      file.writeAsStringSync(
          "$accelerometerSensorValue"); /*Save File to Directory */

      print(file);
    }

    return "Data Accelerometer saved";
  }
}

//Class to Handle the saving of Accelerometer values to Phone Storage
class SaveGyroValues {
  List<String> gyroscopeSensors;
  SaveGyroValues(this.gyroscopeSensors);

  Future<String> localPath() async {
    Directory directory = await getExternalStorageDirectory();

    List<String> path = directory.path.split("/");

    String storepath = "";

    ///storage/emulated/0/Android/data/app.sensor/files

    for (int i = 1; i < path.length; i++) {
      String folder = path[i];

      if (folder != "Android") {
        storepath += "/" + folder;
      } else {
        print("StorePath " + storepath);
        break;
      }
    }

    storepath = storepath + "/SensorApp";
    //Update the directory path to the new path
    directory = Directory(storepath + "/gyro_reading");
    print(directory);

    if (!await directory.exists()) {
      await directory.create(recursive: true); /*Create New Directory */
    }

    /**Get Format Date */
    String fDate = DateFormat().format(DateTime.now());
    if (await directory.exists()) {
      //Save File
      final File file = File("${directory.path}/$fDate.txt");

      //Conver the accelerometerSensor value from List to string before saving
      final gyroscopeSensorValue = gyroscopeSensors.join(" ");

      file.writeAsStringSync(
          "$gyroscopeSensorValue"); /*Save File to Directory */

      print(file);
    }

    return "Data Gyroscope saved";
  }
}
