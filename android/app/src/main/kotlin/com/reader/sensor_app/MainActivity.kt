package com.reader.sensor_app

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class MainActivity : FlutterActivity(), SensorEventListener , EventChannel.StreamHandler {

    private lateinit var sensorManager: SensorManager
    private var sensor: Sensor? = null

    private var eventSink: EventChannel.EventSink? = null


    private val CHANNEL = "com.destiny_ed/magnetic_field"
    
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager

        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

        val event = EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        event.setStreamHandler(this)


    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event!!.sensor.type == Sensor.TYPE_MAGNETIC_FIELD) {
            val values = listOf(event!!.values[0], event.values[1], event.values[2])
            eventSink?.success(values)
            
//            System.arraycopy(event.values, 0, accel, 0, accel.size)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        //Do nothing
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
        registerIfActive()
    }

    override fun onCancel(arguments: Any?) {
        unregisterIfActive()
        eventSink = null
    }


    private fun registerIfActive() {
        if (eventSink == null) return
        sensor = sensorManager!!.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

        // We could play around with samplingPeriodUs (3rd param) here for lower latency
        // e.g. SensorManger.SENSOR_DELAY_GAME
        sensorManager!!.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI, SensorManager.SENSOR_DELAY_UI)
    }

    private fun unregisterIfActive() {
        if (eventSink == null) return
        sensorManager!!.unregisterListener(this)
    }


}



