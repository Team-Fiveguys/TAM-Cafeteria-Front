import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';
import 'package:tam_cafeteria_front/widgets/today_menu_info_widget.dart';
import 'package:tam_cafeteria_front/widgets/week_menu_info_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({
    super.key,
  });

  final DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy / MM / dd');

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> myongjin = {
      'name': '명진당',
      'lunch_hour': "11:30 ~ 14:30",
      'id': 1,
    };

    final Map<String, dynamic> hakgwan = {
      'name': '학생회관',
      'breakfast_hour': "08:00 ~ 09:00",
      'lunch_hour': "10:00 ~ 15:00",
      'id': 2,
    };

    Cafeteria cafeteriaMyongjin = Cafeteria.fromJson(myongjin);
    Cafeteria cafeteriaHakgwan = Cafeteria.fromJson(hakgwan);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(36),
                  color: Theme.of(context).canvasColor,
                ),
                width: 350,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
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
                          color: Color(0xFFF0F0F0),
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
              TodayMenuInfo(
                cafeteriaName: cafeteriaMyongjin.name,
                lunchHour: cafeteriaMyongjin.lunchHour,
              ),
              const SizedBox(
                height: 30,
              ),
              TodayMenuInfo(
                cafeteriaName: cafeteriaHakgwan.name,
                lunchHour: cafeteriaHakgwan.lunchHour,
                breakfastHour: cafeteriaHakgwan.breakfastHour,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          // width: 350,
          height: 56,
          color: Theme.of(context).canvasColor,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '주간 식단표',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            WeekMenuInfo(
              cafeteria: cafeteriaMyongjin,
            ),
            WeekMenuInfo(
              cafeteria: cafeteriaHakgwan,
            ),
          ],
        )
      ],
    );
  }
}
