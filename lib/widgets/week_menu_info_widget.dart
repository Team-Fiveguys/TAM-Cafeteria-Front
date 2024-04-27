import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class WeekMenuInfo extends StatefulWidget {
  const WeekMenuInfo({
    super.key,
    required this.cafeteria,
  });

  final Cafeteria cafeteria;

  @override
  State<WeekMenuInfo> createState() => _WeekMenuInfoState();
}

class _WeekMenuInfoState extends State<WeekMenuInfo> {
  final List<List<String>> menuList = [
    [
      "마제소바",
      "도토리묵야채무침침침",
      "타코야끼",
      "락교",
      "요구르트",
      "아이스믹스커피",
      "배추김치&추가밥",
    ],
    [
      "마제소바",
      "도토리묵야채무침",
      "타코야끼",
      "락교",
      "요구르트",
      "아이스믹스커피",
      "배추김치&추가밥",
    ],
    [
      "마제소바",
      "도토리묵야채무침",
      "타코야끼",
      "락교",
      "요구르트",
      "아이스믹스커피",
      "배추김치&추가밥",
    ],
    [
      "마제소바",
      "도토리묵야채무침",
      "타코야끼",
      "락교",
      "요구르트",
      "아이스믹스커피",
      "배추김치&추가밥",
    ],
    [
      "마제소바",
      "도토리묵야채무침",
      "타코야끼",
      "락교",
      "요구르트",
      "아이스믹스커피",
      "배추김치&추가밥",
    ],
    [],
    [],
  ];

  int today = DateTime.now().weekday; // 1: 월요일, 2: 화요일, ..., 7: 일요일

  int getWeekOfMonth(DateTime date) {
    // 해당 날짜의 달의 첫째 날
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // 첫째 날의 요일 (DateTime에서 월요일은 1, 일요일은 7)
    int firstWeekdayOfMonth = firstDayOfMonth.weekday;

    // 해당 날짜의 일
    int dayOfMonth = date.day;

    // 첫째 날의 요일을 고려하여 몇 주차인지 계산
    // 첫 주의 남은 일수를 계산 (첫째 날이 월요일이 아니면 첫 주는 짧을 수 있음)
    int daysInFirstWeek = 8 - firstWeekdayOfMonth;
    // 첫 주를 제외한 날짜
    int remainingDays = dayOfMonth - daysInFirstWeek;
    // 나머지 날짜를 7로 나누어 몇 주차인지 계산 (0부터 시작하므로 +1)
    int weekOfMonth =
        (remainingDays > 0 ? ((remainingDays - 1) / 7).floor() + 2 : 1);

    return weekOfMonth;
  }

  List<String> days = ["월", "화", "수", "목", "금", "토", "일"];

  // 오늘 요일을 기준으로 리스트를 두 부분으로 나눕니다.
  late List<String> beforeToday;
  late List<String> fromToday;

  // 두 부분을 서로 뒤바꿔서 합칩니다.
  late List<String> reorderedDays;

  @override
  void initState() {
    super.initState();

    beforeToday = days.sublist(0, today - 1);
    fromToday = days.sublist(today - 1);
    reorderedDays = fromToday + beforeToday;
  }

  Color getBorderColor(int index) {
    // 오늘 요일에 해당하는 아이템의 테두리색을 다르게 설정합니다.
    if (index == 0) {
      return Theme.of(context).cardColor; // 오늘 요일에 대한 테두리색
    } else {
      return Colors.white; // 기본 테두리색
    }
  }

  Color getTextColor(int index) {
    // 오늘 요일에 해당하는 아이템의 테두리색을 다르게 설정합니다.
    if (index == 0) {
      return const Color(0xFFF79800); // 오늘 요일에 대한 테두리색
    } else {
      return const Color(0xFFB9B9B9); // 기본 테두리색
    }
  }

  Future<void> getWeekDiets() async {
    final weekNum = getWeekOfMonth(DateTime.now());
    print('week menu info : getWeekDiets : $weekNum');
    await ApiService.getWeekDiets(
        1, DateTime.now().year, DateTime.now().month, weekNum, "LUNCH");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          width: 75,
          height: 33,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1550AA),
          ),
          child: Center(
            child: Text(
              widget.cafeteria.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if (widget.cafeteria.name == "학생회관")
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
                      widget.cafeteria.breakfastHour!,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: FutureBuilder(
                  future: getWeekDiets(),
                  builder: (context, snapshot) => SizedBox(
                    height: 177, // ListView의 높이를 설정합니다.
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤되도록 설정합니다.
                      itemCount: reorderedDays.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 5,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0, // spreadRadius를 줄입니다.
                                blurRadius:
                                    3, // blurRadius를 줄여 그림자의 크기를 작게 합니다.
                                offset: const Offset(0, 0), // 그림자 위치 조정
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          width: 130,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 3,
                                color:
                                    getBorderColor(index), // 인덱스에 따라 경계선 색상 결정
                              ),
                              color: Colors.white, // 안쪽 Container의 배경색
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reorderedDays[index],
                                  style: TextStyle(color: getTextColor(index)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (menuList[(today - 1 + index) % 7].isEmpty)
                                  const Center(
                                    child: Text(
                                      "미운영",
                                      style: TextStyle(
                                        color: Color(0xFF5A5A5A),
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var menu in menuList[
                                              (today - 1 + index) % 7])
                                            Text(
                                              "• $menu",
                                              style: const TextStyle(
                                                color: Color(0xFF5A5A5A),
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                    widget.cafeteria.lunchHour,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SizedBox(
                height: 177, // ListView의 높이를 설정합니다.
                child: ListView.separated(
                  scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤되도록 설정합니다.
                  itemCount: reorderedDays.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 5,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0, // spreadRadius를 줄입니다.
                            blurRadius: 3, // blurRadius를 줄여 그림자의 크기를 작게 합니다.
                            offset: const Offset(0, 0), // 그림자 위치 조정
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      width: 130,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 3,
                            color: getBorderColor(index), // 인덱스에 따라 경계선 색상 결정
                          ),
                          color: Colors.white, // 안쪽 Container의 배경색
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reorderedDays[index],
                              style: TextStyle(color: getTextColor(index)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (menuList[(today - 1 + index) % 7].isEmpty)
                              const Center(
                                child: Text(
                                  "미운영",
                                  style: TextStyle(
                                    color: Color(0xFF5A5A5A),
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var menu
                                          in menuList[(today - 1 + index) % 7])
                                        Text(
                                          "• $menu",
                                          style: const TextStyle(
                                            color: Color(0xFF5A5A5A),
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
