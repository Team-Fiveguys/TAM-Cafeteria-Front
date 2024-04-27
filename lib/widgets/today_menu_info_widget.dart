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

  String? imageUrl;

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
                    child: imageUrl != ""
                        ? Image.network(imageUrl!)
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.hourglass_empty),
                                SizedBox(
                                  height: 40,
                                ),
                                Text('식단 사진이 등록 전입니다.'),
                              ],
                            ),
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
//getdiets
    if (menus != null) {
      imageUrl = menus.imageUrl;
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
                                            // 널 체크
                                            Text(
                                              currentCongestionStatus,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
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
