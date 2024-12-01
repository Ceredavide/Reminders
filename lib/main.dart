import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'screens/home_page.dart';
import 'services/notifications/notification_config.dart';
import 'services/widget/widget_home.dart';

void main() async {
  init();
  runApp(const MyApp());
}

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationConfig.init();
  HomeWidget.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
