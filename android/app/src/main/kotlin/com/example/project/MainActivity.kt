package com.example.project

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // Add this line for manual registration
        flutterEngine.plugins.add(FlutterToastPlugin())
    }
}