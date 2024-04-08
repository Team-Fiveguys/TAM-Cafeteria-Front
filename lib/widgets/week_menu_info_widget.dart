import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';

class WeekMenuInfo extends StatelessWidget {
  const WeekMenuInfo({
    super.key,
    required this.cafeteria,
  });

  final Cafeteria cafeteria;

  @override
  Widget build(BuildContext context) {
    int today = DateTime.now().weekday; // 1: 월요일, 2: 화요일, ..., 7: 일요일
    // 요일을 나타내는 문자열 리스트를 정의합니다.
    List<String> days = ["월", "화", "수", "목", "금", "토", "일"];

    // 오늘 요일을 리스트의 첫 번째 요소로 만들기 위해 리스트를 재배열합니다.
    List<String> reorderedDays = [
      days[today - 1],
      ...days.where((day) => day != days[today - 1]),
    ];

    Color getBackgroundColor(int index) {
      // 오늘 요일에 해당하는 아이템의 배경색을 다르게 설정합니다.
      if (index == 0) {
        return Colors.blue; // 오늘 요일에 대한 배경색
      } else {
        return Colors.white; // 기본 배경색
      }
    }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cafeteria.name),
              ),
            ),
          ),
        ),
        if (cafeteria.breakfastHour != null)
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '조식',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      cafeteria.breakfastHour!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150, // ListView의 높이를 설정합니다.
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤되도록 설정합니다.
                  itemCount: reorderedDays.length, // 아이템의 개수를 설정합니다.
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 100, // 각 아이템의 너비를 설정합니다.

                      child: Card(
                        color: getBackgroundColor(
                            index), // 오늘 요일에 대해서만 배경색을 설정합니다.
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reorderedDays[index]),
                            ], // 요일을 표시합니다.
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '중식',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    cafeteria.lunchHour,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 150, // ListView의 높이를 설정합니다.
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤되도록 설정합니다.
                itemCount: reorderedDays.length, // 아이템의 개수를 설정합니다.
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 100, // 각 아이템의 너비를 설정합니다.

                    child: Card(
                      color:
                          getBackgroundColor(index), // 오늘 요일에 대해서만 배경색을 설정합니다.
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reorderedDays[index]),
                          ], // 요일을 표시합니다.
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ],
    );
  }
}
