import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CoverManagement extends StatefulWidget {
  const CoverManagement({super.key});

  @override
  State<CoverManagement> createState() => _CoverManagementState();
}

class _CoverManagementState extends State<CoverManagement> {
  TextEditingController todayCover = TextEditingController();

  DateTime now = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime _selectedDay;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;
  final List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  bool isExam = false;
  bool isDessertDistribution = false;
  bool isFestival = false;
  bool isReserveForce = false;
  bool isVaccation = false;
  bool isHoliday = false;
  bool isSpicy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = now;
    firstDay = now.subtract(const Duration(days: 7));
    lastDay = firstDay.add(const Duration(days: 21));
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
                    title: const Text(
                      '식수 관리',
                      style: TextStyle(
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
                                  "오늘 식수 입력",
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '개강일',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 5, 5, 5),
                                  ),
                                ),
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
                              setState(() {
                                _selectedDay = selectDay;
                                now = focusedDay;
                                // selectedDay = dateFormat.format(now);
                                print("$selectDay, $focusedDay");
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
                          const SizedBox(
                            height: 30,
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
                            onPressed: () {},
                            child: const Text("결과 보기"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text('예측 식수 :  '),
                        ],
                      ),
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
