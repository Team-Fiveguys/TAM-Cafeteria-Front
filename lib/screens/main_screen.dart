import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/widgets/today_menu_info_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy / MM / dd');
  @override
  Widget build(BuildContext context) {
    // print(now);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 350,
            height: 56,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '오늘의 식단',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateFormat.format(now),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const TodayMenuInfo(
            cafeteriaName: "명진당",
            lunchHour: "11:30 ~ 14:30",
          ),
          const SizedBox(
            height: 30,
          ),
          const TodayMenuInfo(
            cafeteriaName: "학생회관",
            lunchHour: "11:00 ~ 15:00",
            breakfastHour: "08:00 ~ 09:00",
          ),
        ],
      ),
    );
  }
}
