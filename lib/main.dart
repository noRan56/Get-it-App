import 'package:flutter/material.dart';
import 'package:habithiveapp/habit.dart';
import 'package:habithiveapp/util/notify_service.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final notify = NotiService();
  await notify.initNotification();
  await Hive.openBox('Habit_Database');

  runApp(HabitApp());
}
