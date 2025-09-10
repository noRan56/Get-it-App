import 'package:flutter/material.dart';
import 'package:habithiveapp/db/habit_data_base.dart';
import 'package:habithiveapp/homepage.dart';

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}
