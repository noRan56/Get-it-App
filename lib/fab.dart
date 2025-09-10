import 'package:flutter/material.dart';

class FAB extends StatelessWidget {
  final Function()? onPressed;
  const FAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      mini: true,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: const Icon(Icons.add, color: Colors.green),
      backgroundColor: Colors.white,
    );
  }
}
