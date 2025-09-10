import 'package:flutter/material.dart';
import 'package:habithiveapp/pages/nav.dart';

class ArchivePage extends StatelessWidget {
  final List archivedHabits;

  const ArchivePage({super.key, required this.archivedHabits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: NavBarWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Archived Habits'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: archivedHabits.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(archivedHabits[index][0]),
            trailing: const Icon(Icons.check, color: Colors.green),
          );
        },
      ),
    );
  }
}
