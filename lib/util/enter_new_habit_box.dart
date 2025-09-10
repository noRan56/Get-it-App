import 'package:flutter/material.dart';

class EnterNewHabitBox extends StatelessWidget {
  final TextEditingController habitController;
  final String? hintText;
  final VoidCallback onSave, onCancle;
  const EnterNewHabitBox(
      {super.key,
      required this.habitController,
      required this.onSave,
      required this.onCancle,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: TextField(
          style: TextStyle(color: Colors.grey),
          controller: habitController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
              ))),
      actions: [
        MaterialButton(
          onPressed: onSave,
          child: Text('Save',
              style: TextStyle(
                color: Colors.green,
              )),
          color: Colors.white,
        ),
        MaterialButton(
          onPressed: onCancle,
          child: Text('Cancel',
              style: TextStyle(
                color: Colors.red,
              )),
          color: Colors.white,
        )
      ],
    );
  }
}
