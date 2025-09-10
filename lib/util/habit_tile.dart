import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool isCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? settingFunction;

  const HabitTile(
      {super.key,
      required this.habitName,
      required this.isCompleted,
      this.onChanged,
      this.deleteFunction,
      this.settingFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Slidable(
            endActionPane: ActionPane(motion: StretchMotion(), children: [
              SlidableAction(
                onPressed: settingFunction,
                backgroundColor: Colors.grey.shade800,
                icon: Icons.settings,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              SlidableAction(
                flex: 2,
                onPressed: deleteFunction,
                backgroundColor: Colors.grey.shade800,
                icon: Icons.delete,
                foregroundColor: Colors.white,
              )
            ]),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Color.fromARGB(248, 246, 246, 245),
                    activeColor: Colors.green,
                    value: isCompleted,
                    onChanged: onChanged,
                  ),
                  Text(habitName,
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
