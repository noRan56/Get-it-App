import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habithiveapp/db/data_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> dataMap;
  final String firstDate;
  const MyHeatMap({super.key, required this.dataMap, required this.firstDate});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: createDateTimeObject(firstDate),
      endDate: DateTime.now().add(const Duration(days: 1)),
      datasets: dataMap,
      colorMode: ColorMode.color,
      defaultColor: Colors.grey[200],
      showColorTip: false,
      textColor: Colors.green,
      showText: true,
      scrollable: true,
      size: 35,
      colorsets: {
        1: Colors.white,
        2: Colors.green.shade100,
        3: Colors.green.shade200,
        4: Colors.green.shade300,
        5: Colors.green.shade400,
        6: Colors.green.shade500,
        7: Colors.green.shade600,
        8: Colors.green.shade700,
        9: Colors.green.shade800,
        10: Colors.green.shade900
      },
    );
  }
}
