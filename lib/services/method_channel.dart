import 'package:flutter/services.dart';

class AlertMethodChannel {
  static const MethodChannel _channel =
      MethodChannel('com.example.moblab/sound');

  static Future<void> playSound() async {
    try {
      await _channel.invokeMethod('playSound');
    } on PlatformException catch (e) {
      print("Failed to play sound: ${e.message}");
    }
  }
}
