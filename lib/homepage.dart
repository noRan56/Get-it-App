import 'package:flutter/material.dart';
import 'package:habithiveapp/db/habit_data_base.dart';
import 'package:habithiveapp/fab.dart';
import 'package:habithiveapp/pages/nav.dart';
import 'package:habithiveapp/util/enter_new_habit_box.dart';
import 'package:habithiveapp/util/habit_tile.dart';
import 'package:habithiveapp/util/heat_map.dart';
import 'package:habithiveapp/util/notify_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');
  final _habitController = TextEditingController();

  @override
  void initState() {
    if (_myBox.get('CURRENT_HABITS_LIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    db.updateData();
    super.initState();
  }

  void toggleHabit(bool? value, int index) {
    setState(() {
      db.todayHabits[index][1] = value ?? false;
    });
    if (db.todayHabits[index][1] == true) {
      NotiService().showNotification(
        title: "Finished Habit 🔥",
        body: 'You have finished a habit ${db.todayHabits[index][0]} 🔥',
      );
    }
    db.updateData();
  }

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabitBox(
            onSave: saveHabits,
            onCancle: cancleHabit,
            habitController: _habitController,
            hintText: 'Create New Habit',
          );
        });

    db.updateData();
  }

  void saveHabits() {
    if (_habitController.text.isEmpty) {
      return cancleHabit();
    } else {
      setState(() {
        db.todayHabits.insert(0, [_habitController.text, false]);
      });
    }
    NotiService().showNotification(
      title: "New Habit",
      body: 'You have created a new habit ${_habitController.text}  🔥',
    );

    db.updateData();
    _habitController.clear();
    Navigator.pop(context);
  }

  void cancleHabit() {
    _habitController.clear();
    Navigator.pop(context);
  }

  void openHabitSetting(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabitBox(
              hintText: db.todayHabits[index][0],
              onCancle: cancleHabit,
              onSave: () => saveExistingHabit(index),
              habitController: _habitController);
        });
    db.updateData();
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabits[index][0] = _habitController.text;
    });
    NotiService().showNotification(
      title: "Update Habit",
      body: 'You have updated a habit ${_habitController.text}  🔥',
    );

    _habitController.clear();
    Navigator.pop(context);
    db.updateData();
  }

  void deleteExistHabit(int index) {
    setState(() {
      db.todayHabits.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Get it',
          style: TextStyle(color: Colors.green),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: ListView(
          children: [
            MyHeatMap(
                dataMap: db.heatMapDataSet,
                firstDate: _myBox.get('START_DATE')),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todayHabits.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todayHabits[index][0],
                    isCompleted: db.todayHabits[index][1],
                    onChanged: (value) => toggleHabit(value, index),
                    settingFunction: (context) => openHabitSetting(index),
                    deleteFunction: (context) => deleteExistHabit(index),
                  );
                }),
            SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FAB(
        onPressed: createNewHabit,
      ),
    );
  }
}
