package com.example.moblab

import android.media.MediaPlayer
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.moblab/sound"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playSound") {
                playSound()
                result.success("Sound played successfully")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun playSound() {
        println("sound played");
        val mediaPlayer = MediaPlayer.create(this, R.raw.sound)
        mediaPlayer.start()
    }
}