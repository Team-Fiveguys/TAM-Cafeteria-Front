import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/models/menu_model.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:tam_cafeteria_front/widgets/time_indicator_widget.dart';

class TodayMenuInfo extends StatefulWidget {
  const TodayMenuInfo({
    super.key,
    required this.cafeteriaName,
    required this.lunchHour,
    this.breakfastHour,
  });
  final String cafeteriaName;
  final String lunchHour;
  final String? breakfastHour;

  @override
  State<TodayMenuInfo> createState() => _TodayMenuInfoState();
}

class _TodayMenuInfoState extends State<TodayMenuInfo> {
  final DateTime now = DateTime.now();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  bool isSoldOut = false;
  String currentCongestionStatus = "보통";

  ValueNotifier<int> refreshNotifier = ValueNotifier(0);

  List<String> menuList = [
    "마제소바",
    "도토리묵야채무침calclalcal",
    "타코야끼",
    "락교",
    "요구르트",
    "아이스믹스커피",
    "배추김치&추가밥",
  ];

  final Map<String, String> congestionImage = {
    '여유': 'assets/images/easy.png',
    '보통': 'assets/images/normal.png',
    '혼잡': 'assets/images/busy.png',
    '매우혼잡': 'assets/images/veryBusy.png',
  };

  final Map<String, String> congestionTime = {
    '여유': '약 0~5분',
    '보통': '약 5분~10분',
    '혼잡': '약 10분~20분',
    '매우혼잡': '약 20분~',
  };

  @override
  void initState() {
    super.initState();
    _loadMenu(); // 메뉴 데이터 로드
  }

  void _loadMenu() async {
    final menus = await getDietsInMain(
        widget.cafeteriaName == "학생회관" ? 'BREAKFAST' : 'LUNCH');
    setState(() {
      menuList = menus; // 상태 업데이트
    });
  }

  void popUpMenuImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // 화면 너비에 따른 조건부 패딩 값 설정
        double horizontalPadding = 20;
        double allPading = 15;
        if (MediaQuery.of(context).size.width < 360) {
          if (MediaQuery.of(context).size.width < 310) {
            allPading = 10;
            horizontalPadding = 0;
          } else {
            horizontalPadding = 10;
          }
        }

        return Dialog(
          child: SizedBox(
            width: 350, // 팝업창의 너비
            height: 450, // 팝업창의 높이
            child: Padding(
              padding: EdgeInsets.all(allPading),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close), // X 아이콘
                      onPressed: () {
                        Navigator.of(context).pop(); // 팝업 닫기
                      },
                    ),
                  ),
                  SizedBox(
                    width: 270,
                    height: 210,
                    child: Image.network(
                        'data:image/jpeg;base64,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' // 여기에 실제 이미지 URL을 넣으세요
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF0186D1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.cafeteriaName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                Text(
                                  dateFormat.format(now),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var menu in menuList)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    child: Text(
                                      "• $menu",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration getBorderColor(BuildContext context, String operatingTime) {
    // operatingTime에서 시작 시간과 종료 시간을 분리합니다.
    final times = operatingTime.split(' ~ ');
    final startTimeStr = times[0];
    final endTimeStr = times[1];

    // 현재 시간을 가져옵니다.
    final now = DateTime.now();

    // 문자열로부터 TimeOfDay 객체를 생성합니다.
    TimeOfDay startTime = TimeOfDay(
        hour: int.parse(startTimeStr.split(':')[0]),
        minute: int.parse(startTimeStr.split(':')[1]));
    TimeOfDay endTime = TimeOfDay(
        hour: int.parse(endTimeStr.split(':')[0]),
        minute: int.parse(endTimeStr.split(':')[1]));

    // TimeOfDay를 DateTime으로 변환합니다(날짜는 현재 날짜를 사용).
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // 현재 시간이 운영 시간 내에 있는지 확인합니다.
    bool isOperating = now.isAfter(startDateTime) && now.isBefore(endDateTime);

    // 조건에 따라 테두리 색상을 결정합니다.
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: isOperating
            ? Theme.of(context).cardColor
            : Theme.of(context).dividerColor,
        width: isOperating ? 3 : 1,
      ),
      boxShadow: [
        if (isOperating)
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0, // spreadRadius를 줄입니다.
            blurRadius: 3, // blurRadius를 줄여 그림자의 크기를 작게 합니다.
            offset: const Offset(0, 3), // 그림자 위치 조정
          ),
      ],
      borderRadius: BorderRadius.circular(15),
    );
  }

  Future<void> getCongestionStatus() async {
    currentCongestionStatus = await ApiService.getCongestionStatus(
        widget.cafeteriaName == "명진당" ? 1 : 1); // TODO : 학생회관 Id 설정하기
  }

  Future<List<String>> getDietsInMain(String meals) async {
    Menu? menus = await ApiService.getDiets(dateFormat.format(now), meals);
    if (menus != null) {
      return menus.names;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 5),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.cafeteriaName,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => popUpMenuImage(context), //메뉴 사진 팝업 함수 필요
                  child: Row(
                    children: [
                      Text(
                        '메뉴 사진 보기',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 8,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(children: [
                    TimeIndicator(
                      lunchHour: widget.lunchHour,
                      breakfastHour: widget.breakfastHour,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 130,
                      decoration: getBorderColor(
                          context,
                          widget.cafeteriaName == "학생회관"
                              ? widget.breakfastHour!
                              : widget.lunchHour),
                      child: Center(
                        child: SingleChildScrollView(
                          child: FutureBuilder(
                            future: getDietsInMain(
                                widget.cafeteriaName == "학생회관"
                                    ? 'BREAKFAST'
                                    : 'LUNCH'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // 에러 발생 시
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return isSoldOut
                                    ? soldOutWidget()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (var menu in menuList)
                                            Text(
                                              "• $menu",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontSize: 10,
                                              ),
                                            )
                                        ],
                                      );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      widget.breakfastHour != null
                          ? TimeIndicator(
                              lunchHour: widget.lunchHour,
                            )
                          : const TimeIndicator(
                              name: "명분이네",
                              lunchHour: "11:00 ~ 15:00",
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        height: 130,
                        decoration: getBorderColor(
                            context,
                            widget.cafeteriaName == "학생회관"
                                ? widget.lunchHour
                                : "11:00 ~ 15:00"),
                        child: Center(
                          child: SingleChildScrollView(
                            child: FutureBuilder(
                              future: getDietsInMain(
                                  widget.cafeteriaName == "학생회관"
                                      ? 'BREAKFAST'
                                      : 'LUNCH'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // 에러 발생 시
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return isSoldOut
                                      ? soldOutWidget()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (var menu in menuList)
                                              Text(
                                                "• $menu",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontSize: 10,
                                                ),
                                              )
                                          ],
                                        );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      RichText(text: const TextSpan()),
                      const SizedBox(
                        height: 6,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: refreshNotifier,
                                builder: (context, value, child) {
                                  return FutureBuilder(
                                    future: getCongestionStatus(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        // 에러 발생 시
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 67,
                                              height: 36,
                                              child: Image.asset(
                                                congestionImage[
                                                    currentCongestionStatus]!,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Text(
                                              currentCongestionStatus,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              congestionTime[
                                                  currentCongestionStatus]!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.refresh,
                                size: 15,
                              ),
                              onPressed: () {
                                refreshNotifier.value +=
                                    1; // 이렇게 하면 ValueListenableBuilder가 rebuild됩니다.
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column soldOutWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset('assets/images/soldOut.png'),
        ),
        const Text('품절'),
      ],
    );
  }
}
