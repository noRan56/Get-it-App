import 'package:habithiveapp/db/data_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box('Habit_Database');

class HabitDatabase {
  List todayHabits = [];
  List archivedHabits = [];

  Map<DateTime, int> heatMapDataSet = {};

  // inital data
  void createInitialData() {
    todayHabits = [
      ['Habit 1', false]
    ];

    _myBox.put('CURRENT_HABITS_LIST', todayHabits);
    _myBox.put(todaysDateFormatted(), todayHabits);
    _myBox.put('ARCHIVED_HABITS', archivedHabits);

    _myBox.put('START_DATE', todaysDateFormatted());
  }

  // load data
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todayHabits = _myBox.get('CURRENT_HABITS_LIST') ?? [];
      for (int i = 0; i < todayHabits.length; i++) {
        todayHabits[i][1] = false;
      }
    } else {
      todayHabits = _myBox.get(todaysDateFormatted());
    }
  }

  //update data
  void updateData() {
    print('Updating data: $todayHabits');
    _myBox.put(todaysDateFormatted(), todayHabits);
    _myBox.put('CURRENT_HABITS_LIST', todayHabits);
    // Only set START_DATE if it doesn't exist
    if (_myBox.get('START_DATE') == null || _myBox.get('START_DATE') == '') {
      _myBox.put('START_DATE', todaysDateFormatted());
    }
    calculatePercentage();
    loadHeatMap();
  }

  void calculatePercentage({String? specificDate}) {
    int countCompleted = 0;
    // Get the habits for the specified date or today's date
    String date = specificDate ?? todaysDateFormatted();
    List habits = _myBox.get(date) ?? [];

    for (var habit in habits) {
      if (habit[1] == true) {
        countCompleted++;
      }
    }

    String percentage = habits.isEmpty
        ? '0.0'
        : ((countCompleted / habits.length) * 100).toStringAsFixed(0);

    // Save the percentage for the specific date
    _myBox.put('PERCENTAGE$date', percentage);
  }

  void loadHeatMap() {
    String? startDateStr = _myBox.get('START_DATE');

    if (startDateStr == null || startDateStr.isEmpty) {
      print('🚨 START_DATE is null or empty. Heatmap loading aborted.');
      return;
    }

    DateTime startDate = createDateTimeObject(startDateStr);

    // Ensures we include the full current day
    DateTime now = DateTime.now();
    DateTime endDate =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    int totalDays = endDate.difference(startDate).inDays;

    // ✅ Clear previous heatmap data to prevent duplicate entries
    heatMapDataSet.clear();

    for (int i = 0; i < totalDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String yyyymmdd = covertDateTimeToString(currentDate);

      String? percentageStr = _myBox.get('PERCENTAGE$yyyymmdd');
      double strength = 0.0;

      // ✅ Improved error handling for percentage values
      if (percentageStr != null && percentageStr.isNotEmpty) {
        try {
          strength = double.parse(percentageStr);
        } catch (e) {
          print('❌ Error parsing percentage for $yyyymmdd: $e');
          continue; // Skip invalid data
        }
      }

      // ✅ Only add non-zero values to reduce clutter in the heatmap
      if (strength > 0) {
        int normalizedValue = (strength / 10).clamp(1, 10).toInt();
        heatMapDataSet[DateTime(
                currentDate.year, currentDate.month, currentDate.day)] =
            normalizedValue;

        // 🟢 Debug output for successful entries
        print(
            '✅ Date: $yyyymmdd, Strength: $strength, Normalized Value: $normalizedValue');
      } else {
        // ⚠️ Debug output for skipped entries
        print('⚠️ Date: $yyyymmdd has zero strength, skipped from heatmap.');
      }
    }
  }

  void archiveCompletedTasks() {
    List completedTasks =
        todayHabits.where((habit) => habit[1] == true).toList();

    // Add completed tasks to archive
    archivedHabits.addAll(completedTasks);

    // Remove completed tasks from today's list
    todayHabits.removeWhere((habit) => habit[1] == true);

    // Save to Hive
    _myBox.put('ARCHIVED_HABITS', archivedHabits);
    _myBox.put(todaysDateFormatted(), todayHabits);

    // Recalculate the heatmap data
    calculatePercentage();
    loadHeatMap();
  }
}
