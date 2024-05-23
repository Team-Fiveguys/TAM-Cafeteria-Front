import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tam_cafeteria_front/models/diet_model.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class CoverManagement extends StatefulWidget {
  const CoverManagement({
    super.key,
    required this.cafeteriaId,
    required this.cafeteriaName,
  });
  final int cafeteriaId;
  final String cafeteriaName;
  @override
  State<CoverManagement> createState() => _CoverManagementState();
}

class _CoverManagementState extends State<CoverManagement> {
  TextEditingController todayCover = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  DateTime now = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime _selectedDay;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  CalendarFormat calendarFormat = CalendarFormat.month;
  final List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  bool isExam = false;
  bool isDessertDistribution = false;
  bool isFestival = false;
  bool isReserveForce = false;
  bool isVaccation = false;
  bool isHoliday = false;
  bool isSpicy = false;

  bool isLoading = false;

  String predictResult = "결과 보기를 눌러 \n예측 식수값을 확인하세요";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = now;
    firstDay = DateTime(2023, 3, 20);
    lastDay = now.add(const Duration(days: 14));
  }

  Future<String?> loadSemesterStartDate = ApiService.getSemesterStartDateAI();

  Future<void> postPredictCovers() async {
    setState(() {
      isLoading = true;
    });

    final startDate = startDateController.text;
    final date = dateFormat.format(_selectedDay);

    try {
      final result = await ApiService.postPredictCoversAI(
              startDate,
              date,
              widget.cafeteriaId,
              isFestival,
              isDessertDistribution,
              isReserveForce,
              isSpicy)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        // 타임아웃 시 실행될 로직
        return "에러"; // 타임아웃이 발생하면 "에러"라는 문자열을 반환합니다.
      });

      setState(() {
        predictResult = result!;
        isLoading = false;
      });
    } on Exception catch (e) {
      // 타임아웃 외의 다른 에러 처리
      setState(() {
        predictResult = e.toString();
        isLoading = false;
      });
    }
  }

  Future<String> getMainMenu() async {
    final date = dateFormat.format(_selectedDay);
    final diet = await ApiService.getDiets(date, "LUNCH", widget.cafeteriaId);
    if (diet != null) {
      if (diet.names.isNotEmpty) {
        return diet.names[0];
      }
    }
    return "식단 미등록";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                // Expanded로 Row의 자식을 감싸서 중앙 정렬 유지
                child: SizedBox(
                  height: 50,
                  child: Image.asset(
                    'assets/images/app_bar_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppBar(
                    backgroundColor: Theme.of(context).canvasColor,
                    automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼을 비활성화
                    leading: IconButton(
                      // leading 위치에 아이콘 버튼 배치
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      '식수 관리 (${widget.cafeteriaName})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true, // title을 중앙에 배치
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // 그림자 위치 조정
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      // height: 220,
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Flexible(
                                child: Text(
                                  "실제 식수",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                height: 45,
                                child: TextField(
                                  controller: todayCover,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'ex) 600',
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 5, 5, 5),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    shape: const RoundedRectangleBorder(
                                      // 테두리 모양을 정의
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15)), // 테두리의 둥근 모서리 정도 설정
                                      // 테두리의 색상과 두께 설정
                                    ),
                                    minimumSize: const Size(60, 45)),
                                onPressed: () {},
                                child: const Text("저장"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                '개강일',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: FutureBuilder(
                                    future: loadSemesterStartDate,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        //  startDateController.text = snapshot.data
                                        print(
                                            "coverManagement : snapshot data : ${snapshot.data.toString()}");
                                        startDateController.text =
                                            snapshot.data ?? "";
                                      }
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        startDateController.text =
                                            snapshot.data ?? "";
                                      }

                                      return TextField(
                                        controller: startDateController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 5, 5, 5),
                                          hintText: "ex) 2024-01-01",
                                        ),
                                      );
                                    }),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    shape: const RoundedRectangleBorder(
                                      // 테두리 모양을 정의
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15)), // 테두리의 둥근 모서리 정도 설정
                                      // 테두리의 색상과 두께 설정
                                    ),
                                    minimumSize: const Size(60, 45)),
                                onPressed: () {},
                                child: const Text("저장"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'AI 모델 made by 엄',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TableCalendar(
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                            ),
                            daysOfWeekHeight: 30,
                            focusedDay: now,
                            firstDay: firstDay,
                            lastDay: lastDay,
                            calendarFormat: calendarFormat,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectDay, focusedDay) {
                              getMainMenu();
                              setState(() {
                                _selectedDay = selectDay;
                                now = focusedDay;
                                // isDessertDistribution = false;
                                // isFestival = false;
                                // isReserveForce = false;
                                // is
                                predictResult = "";
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              dowBuilder: (context, day) {
                                return Center(
                                    child: Text(
                                  daysOfWeek[day.weekday - 1],
                                  style: TextStyle(
                                      color: day.weekday - 1 == 5
                                          ? Colors.blue
                                          : day.weekday - 1 == 6
                                              ? Colors.red
                                              : Colors.black),
                                ));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: FutureBuilder(
                              future: getMainMenu(),
                              builder: (context, snapshot) {
                                String mainMenu = "식단 미등록";
                                if (snapshot.hasData) {
                                  mainMenu = snapshot.data!;
                                }
                                return Text(
                                  '메인 메뉴 : $mainMenu',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       activeColor: Colors.blue,
                          //       value: isExam,
                          //       onChanged: (bool? value) async {
                          //         setState(() {
                          //           isExam = value!;
                          //         });
                          //       },
                          //     ),
                          //     const Text('시험기간 유무'),
                          //   ],
                          // ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.blue,
                                value: isFestival,
                                onChanged: (bool? value) async {
                                  setState(() {
                                    isFestival = value!;
                                  });
                                },
                              ),
                              const Text('축제 유무'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.blue,
                                value: isDessertDistribution,
                                onChanged: (bool? value) async {
                                  setState(() {
                                    isDessertDistribution = value!;
                                  });
                                },
                              ),
                              const Text('간식배부 유무'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.blue,
                                value: isReserveForce,
                                onChanged: (bool? value) async {
                                  setState(() {
                                    isReserveForce = value!;
                                  });
                                },
                              ),
                              const Text('예비군 유무'),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       activeColor: Colors.blue,
                          //       value: isVaccation,
                          //       onChanged: (bool? value) async {
                          //         setState(() {
                          //           isVaccation = value!;
                          //         });
                          //       },
                          //     ),
                          //     const Text('방학 유무'),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       activeColor: Colors.blue,
                          //       value: isHoliday,
                          //       onChanged: (bool? value) async {
                          //         setState(() {
                          //           isHoliday = value!;
                          //         });
                          //       },
                          //     ),
                          //     const Text('공휴일 유무'),
                          //   ],
                          // ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.blue,
                                value: isSpicy,
                                onChanged: (bool? value) async {
                                  setState(() {
                                    isSpicy = value!;
                                  });
                                },
                              ),
                              const Text('매움 유무'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              postPredictCovers();
                            },
                            child: const Text("결과 보기"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          isLoading
                              ? const CircularProgressIndicator()
                              : Center(
                                  child: Text(
                                  '예측 식수 :  $predictResult',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                )),

                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
