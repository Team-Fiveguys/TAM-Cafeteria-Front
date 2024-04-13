import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';

class WeekMenuInfo extends StatelessWidget {
  WeekMenuInfo({
    super.key,
    required this.cafeteria,
  });

  final Cafeteria cafeteria;

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
  @override
  Widget build(BuildContext context) {
    int today = DateTime.now().weekday; // 1: 월요일, 2: 화요일, ..., 7: 일요일
    List<String> days = ["월", "화", "수", "목", "금", "토", "일"];

    // 오늘 요일을 기준으로 리스트를 두 부분으로 나눕니다.
    List<String> beforeToday = days.sublist(0, today - 1);
    List<String> fromToday = days.sublist(today - 1);

    // 두 부분을 서로 뒤바꿔서 합칩니다.
    List<String> reorderedDays = fromToday + beforeToday;
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
              cafeteria.name,
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
        if (cafeteria.name == "학생회관")
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
                        borderRadius: BorderRadius.circular(
                            15), // 여기에 borderRadius를 추가하여 그림자에도 적용됩니다.
                        color: Colors.white, // 이 컨테이너의 배경색도 설정할 수 있습니다.
                      ),
                      width: 100,
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
                              height: 10,
                            ),
                            if (menuList[(today - 1 + index) % 7].isEmpty)
                              const Center(
                                child: Text(
                                  "미운영",
                                  style: TextStyle(
                                    color: Color(0xFF5A5A5A),
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            else
                              // 메뉴 리스트가 비어 있지 않은 경우, 각 메뉴 항목을 순회합니다.
                              for (var menu
                                  in menuList[(today - 1 + index) % 7])
                                Text(
                                  "• $menu",
                                  style: const TextStyle(
                                    color: Color(0xFF5A5A5A),
                                    fontSize: 8,
                                  ),
                                )
                          ],
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
                      borderRadius: BorderRadius.circular(
                          15), // 여기에 borderRadius를 추가하여 그림자에도 적용됩니다.
                      color: Colors.white, // 이 컨테이너의 배경색도 설정할 수 있습니다.
                    ),
                    width: 100,
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
                            height: 10,
                          ),
                          if (menuList[(today - 1 + index) % 7].isEmpty)
                            const Center(
                              child: Text(
                                "미운영",
                                style: TextStyle(
                                  color: Color(0xFF5A5A5A),
                                  fontSize: 10,
                                ),
                              ),
                            )
                          else
                            // 메뉴 리스트가 비어 있지 않은 경우, 각 메뉴 항목을 순회합니다.
                            for (var menu in menuList[(today - 1 + index) % 7])
                              Text(
                                "• $menu",
                                style: const TextStyle(
                                  color: Color(0xFF5A5A5A),
                                  fontSize: 8,
                                ),
                              )
                        ],
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
