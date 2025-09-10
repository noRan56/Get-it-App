import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:habithiveapp/db/habit_data_base.dart';
import 'package:habithiveapp/homepage.dart';
import 'package:habithiveapp/pages/archive.dart';

class NavBarWidget extends StatefulWidget {
  final HabitDatabase db;
  const NavBarWidget({super.key, required this.db});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      backgroundColor: Colors.white,
      color: Colors.green.shade200,
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
        Icon(Icons.list, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        setState(() {
          _page = index;
        });
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArchivePage(
                archivedHabits: widget.db.archivedHabits,
              ),
            ),
          );
        } else if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      },
    );
  }
}
