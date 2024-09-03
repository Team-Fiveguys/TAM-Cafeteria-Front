import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';
import 'package:tam_cafeteria_front/models/diet_model.dart';
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
  Map<String, Diet?> weekDietBreakfastList = {};
  Map<String, Diet?> weekDietLunchList = {};

  DateTime today = DateTime.now(); // 1: 월요일, 2: 화요일, ..., 7: 일요일
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  String formatToday = "";
  Map<String, int> getWeekOfMonth(DateTime date) {
    // 해당 날짜가 속한 주의 목요일 구하기
    int deltaToThursday = (DateTime.thursday - date.weekday) % 7;
    DateTime thursdayOfWeek = date.add(Duration(days: deltaToThursday));

    // 목요일의 달의 첫째 날
    DateTime firstDayOfMonth =
        DateTime(thursdayOfWeek.year, thursdayOfWeek.month, 1);
    // 첫째 날의 요일
    int firstWeekdayOfMonth = firstDayOfMonth.weekday;

    // 첫 주의 남은 일수 계산
    int daysInFirstWeek = 8 - firstWeekdayOfMonth;
    // 첫 주를 제외한 날짜
    int remainingDays = thursdayOfWeek.day - daysInFirstWeek;
    // 나머지 날짜를 7로 나누어 몇 주차인지 계산 (0부터 시작하므로 +1)
    int weekOfMonth =
        (remainingDays > 0 ? ((remainingDays - 1) / 7).floor() + 2 : 1);

    // 해당 목요일이 속한 달과 주차 정보 반환
    return {"month": thursdayOfWeek.month, "weekOfMonth": weekOfMonth};
  }

  List<String> days = ["월", "화", "수", "목", "금", "토", "일"];

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    formatToday = dateFormat.format(today);
  }

  Color getBorderColor(String date) {
    // 오늘 요일에 해당하는 아이템의 테두리색을 다르게 설정합니다.
    if (date == formatToday) {
      return Theme.of(context).cardColor; // 오늘 요일에 대한 테두리색
    } else {
      return Colors.white; // 기본 테두리색
    }
  }

  Color getTextColor(String date) {
    // 오늘 요일에 해당하는 아이템의 테두리색을 다르게 설정합니다.
    if (date == formatToday) {
      return const Color(0xFFF79800); // 오늘 요일에 대한 테두리색
    } else {
      return const Color(0xFFB9B9B9); // 기본 테두리색
    }
  }

  String formatDateString(String dateString) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
    String formattedDate = DateFormat('M/d').format(dateTime);
    return formattedDate;
  }

  Future<void> getWeekDiets() async {
    // print('이제 몇번인가요?');
    weekDietBreakfastList = {};
    weekDietLunchList = {};

    Map<String?, Diet> totalWeek = {};
    try {
      totalWeek = await ApiService.getDietsInMain(widget.cafeteria.id);
    } catch (e) {
      print(e);
    }
    final now = DateTime.now();

    final lastMonday = now.subtract(Duration(days: now.weekday + 6));

    final nextSunday = now.add(Duration(days: 14 - now.weekday));
    DateTime currentDate = lastMonday;

    while (currentDate.isBefore(nextSunday.add(const Duration(days: 1)))) {
      final formatDate = dateFormat.format(currentDate);
      if (totalWeek.containsKey(formatDate) &&
          totalWeek[formatDate]!.meals == "LUNCH") {
        weekDietLunchList[formatDate] = totalWeek[formatDate];
      } else {
        weekDietLunchList[formatDate] = null;
      }
      if (totalWeek.containsKey(formatDate) &&
          totalWeek[formatDate]!.meals == "BREAKFAST") {
        weekDietBreakfastList[formatDate] = totalWeek[formatDate];
      } else {
        weekDietBreakfastList[formatDate] = null;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
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
        FutureBuilder(
          future: getWeekDiets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // 에러 발생 시
              return Text('Error: ${snapshot.error}');
            } else {
              List<String> dateList = weekDietLunchList.keys.toList();
              int initialIndex = dateList.indexOf(formatToday);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (initialIndex != -1) {
                  // 오늘 날짜가 리스트에 있으면
                  _controller
                      .jumpTo(initialIndex * 130.0); // 각 아이템의 너비가 130.0이라고 가정
                }
              });
              List<String> breakfastDateList =
                  weekDietBreakfastList.keys.toList();

              return Column(
                children: [
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
                          child: SizedBox(
                            height: 177, // ListView의 높이를 설정합니다.
                            child: ListView.separated(
                              controller: _controller,
                              scrollDirection:
                                  Axis.horizontal, // 가로 방향으로 스크롤되도록 설정합니다.
                              itemCount: breakfastDateList.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 5,
                                );
                              },
                              itemBuilder: (context, index) {
                                final date = breakfastDateList[index];
                                DateTime dateTime = DateTime.parse(date);

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
                                        color: getBorderColor(
                                            date), // 인덱스에 따라 경계선 색상 결정
                                      ),
                                      color: Colors.white, // 안쪽 Container의 배경색
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              days[dateTime.weekday - 1],
                                              style: TextStyle(
                                                  color: getTextColor(date)),
                                            ),
                                            Text(
                                              formatDateString(date),
                                              style: TextStyle(
                                                  color: getTextColor(date)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        if (weekDietBreakfastList[date] == null)
                                          const Center(
                                            child: Text(
                                              "미등록",
                                              style: TextStyle(
                                                color: Color(0xFF5A5A5A),
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        else if (weekDietBreakfastList[date]!
                                            .dayOff)
                                          const Center(
                                            child: Text(
                                              "미운영",
                                              style: TextStyle(
                                                color: Color(0xFF5A5A5A),
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        else if (weekDietBreakfastList[date]!
                                            .names
                                            .isEmpty)
                                          const Center(
                                            child: Text(
                                              "미등록",
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
                                                      in weekDietBreakfastList[
                                                              date]!
                                                          .names)
                                                    Text(
                                                      "• $menu",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF5A5A5A),
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
                        controller: _controller,
                        scrollDirection:
                            Axis.horizontal, // 가로 방향으로 스크롤되도록 설정합니다.
                        itemCount: dateList.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 5,
                          );
                        },
                        itemBuilder: (context, index) {
                          final date = dateList[index];
                          DateTime dateTime = DateTime.parse(date);

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
                                      getBorderColor(date), // 인덱스에 따라 경계선 색상 결정
                                ),
                                color: Colors.white, // 안쪽 Container의 배경색
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        days[dateTime.weekday - 1],
                                        style: TextStyle(
                                            color: getTextColor(date)),
                                      ),
                                      Text(
                                        formatDateString(date),
                                        style: TextStyle(
                                            color: getTextColor(date)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (weekDietLunchList[date] == null)
                                    const Center(
                                      child: Text(
                                        "미등록",
                                        style: TextStyle(
                                          color: Color(0xFF5A5A5A),
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  else if (weekDietLunchList[date]!.dayOff)
                                    const Center(
                                      child: Text(
                                        "미운영",
                                        style: TextStyle(
                                          color: Color(0xFF5A5A5A),
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  else if (weekDietLunchList[date]!
                                      .names
                                      .isEmpty)
                                    const Center(
                                      child: Text(
                                        "미등록",
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
                                                in weekDietLunchList[date]!
                                                    .names)
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
                ],
              );
            }
          },
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
