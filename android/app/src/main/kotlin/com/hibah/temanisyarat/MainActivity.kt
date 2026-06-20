package com.hibah.temanisyarat

import com.hibah.temanisyarat.handlandmarker.HandLandmarkerPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(HandLandmarkerPlugin())
        super.configureFlutterEngine(flutterEngine)
    }
}
