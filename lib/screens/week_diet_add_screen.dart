import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tam_cafeteria_front/functions/menu_add_function.dart';
import 'package:tam_cafeteria_front/main.dart';
import 'package:tam_cafeteria_front/models/diet_model.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class WeekDiet extends StatefulWidget {
  const WeekDiet({
    super.key,
    required this.cafeteriaName,
    required this.cafeteriaId,
    required this.mealList,
  });
  final String cafeteriaName;
  final int cafeteriaId;
  final List<String> mealList;
  @override
  State<WeekDiet> createState() => _WeekDietState();
}

class _WeekDietState extends State<WeekDiet> {
  late Future<Diet> menuList;
  late int initMenuListLength;
  List<String> filteredMenus = [];

  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  DateTime now = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime _selectedDay;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  String? selectedItem = '중식';

  final List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
  Map<String, List<String>> weekMenus = {};
  Map<String, bool?> operationalDays = {};
  String? searchText;
  String selectedMeals = "LUNCH";
  late String selectedDay;
  int selectedDayIndex = DateTime.now().weekday - 1;
  List<String> selectedMenusForBulk = [];
  Set<DateTime> selectedDates = {};
  bool isExpanded = false;

  bool isLoading = false;

  String? selectedCategory; // 선택된 카테고리를 저장할 변수
  final TextEditingController menuNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    menuList = ApiService.getMenu(widget.cafeteriaId);
    _selectedDay = now;
    firstDay = now.subtract(const Duration(days: 7));
    lastDay = firstDay.add(const Duration(days: 21));

    menuNameController.addListener(filteringMenus);
    selectedDay = dateFormat.format(now);
    initDietList();
  }

  Future<void> initDietList() async {
    setState(() {
      isLoading = true;
    });
    DateTime currentDate = firstDay;
    while (currentDate.isBefore(lastDay.add(const Duration(days: 1)))) {
      // lastDay를 포함하기 위해 1일 추가
      String formattedDate = dateFormat.format(currentDate);
      Diet? todayDiets = await ApiService.getDiets(
          formattedDate, selectedMeals, widget.cafeteriaId);
      if (todayDiets != null) {
        weekMenus[formattedDate] = todayDiets.names;
        operationalDays[formattedDate] = todayDiets.dayOff;
      } else {
        weekMenus[formattedDate] = [];
        operationalDays[formattedDate] = false;
      }
      // weekMenus[formattedDate] = []; // formattedDate를 key로 하여 비어 있는 리스트 할당
      // 기본적으로 모든 날짜를 운영으로 설정

      currentDate =
          currentDate.add(const Duration(days: 1)); // currentDate를 다음 날짜로 업데이트
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> filteringMenus() async {
    // 비동기 함수로 변경
    String query = menuNameController.text;
    Diet menuResult = await menuList;
    List<String> menuListResult = menuResult.names; // await를 사용하여 비동기 처리
    List<String> selectedDayMenus = weekMenus[selectedDay] ?? [];
    setState(() {
      filteredMenus = menuListResult
          .where((menu) => menu.toLowerCase().contains(query.toLowerCase()))
          .where((menu) => !selectedDayMenus.contains(menu))
          .toList();
    });
  }

  void registeringDiets() async {
    try {
      await ApiService.postDiets(weekMenus[selectedDay]!, selectedDay,
          selectedMeals, widget.cafeteriaId, operationalDays[selectedDay]!);
      setState(() {});
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void registerMenusForSelectedDates() async {
    for (DateTime selectedDate in selectedDates) {
      String selectedDayFormat = dateFormat.format(selectedDate);

      for (String menu in selectedMenusForBulk) {
        await registerMenuForADate(menu, selectedDayFormat);
      }
    }

    // 모든 메뉴가 등록된 후 UI 업데이트
    setState(() {});
  }

  Future<void> registerMenuForADate(String menuName, String date) async {
    try {
      await ApiService.putDiets(
        menuName,
        date,
        selectedMeals,
        widget.cafeteriaId,
      );
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void registerMultiMenuInDiets() async {
    try {
      for (var selectedDate in selectedDates) {
        String selectedDay = dateFormat.format(selectedDate);

        // 기존 메뉴를 API에서 가져옵니다.
        Diet? existingDiets = await ApiService.getDiets(
            selectedDay, selectedMeals, widget.cafeteriaId);
        List<String> existingMenus = existingDiets?.names ?? [];

        if (existingMenus.isEmpty) {
          // 기존 메뉴가 없으면 postDiets를 사용하여 새로운 메뉴를 추가합니다.
          await ApiService.postDiets(
            selectedMenusForBulk,
            selectedDay,
            selectedMeals,
            widget.cafeteriaId,
            false,
          );
        } else {
          // 기존 메뉴가 있는 경우
          for (var menu in selectedMenusForBulk) {
            if (!existingMenus.contains(menu)) {
              // 선택된 메뉴가 이미 존재하지 않으면 putDiets를 사용하여 추가합니다.
              await ApiService.putDiets(
                menu,
                selectedDay,
                selectedMeals,
                widget.cafeteriaId,
              );
            } else {}
          }
        }
      }
      setState(() {});
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void registeringOneMenuInDiets(String menuName) async {
    try {
      await ApiService.putDiets(
        menuName,
        selectedDay,
        selectedMeals,
        widget.cafeteriaId,
      );
      setState(() {});
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void removeOneMenuInDiets(String menuName) async {
    try {
      await ApiService.deleteDiets(
        menuName,
        selectedDay,
        selectedMeals,
        widget.cafeteriaId,
      ).then((_) {
        setState(() {
          weekMenus[selectedDay]?.remove(menuName);
        });
      });
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void showDietAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("메뉴 추가"),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 300,
                  height: 416,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DropdownButton<String>(
                      //   hint: const Text("카테고리 선택"),
                      //   value: selectedCategory,
                      //   dropdownColor: Colors.white,
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       selectedCategory = newValue;
                      //     });
                      //   },
                      //   items: <String>['한식', '중식', '일식', '양식']
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                      TextField(
                        controller: menuNameController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "메뉴 명",
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: menuList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.names;

                              final currentMenus = weekMenus[selectedDay] ?? [];
                              data = data
                                  .where((menu) => !currentMenus.contains(menu))
                                  .toList();

                              return ListView.builder(
                                itemCount: menuNameController.text.isEmpty
                                    ? data.length
                                    : filteredMenus.length,
                                itemBuilder: (context, index) {
                                  final item = menuNameController.text.isEmpty
                                      ? data[index]
                                      : filteredMenus[index];
                                  return ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      setState(() {
                                        menuNameController.text = item;
                                      });
                                    },
                                  );
                                },
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '원하는 메뉴가 없나요?',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await showMenuInput(
                                  context, setState, widget.cafeteriaId)
                              .then((_) {});
                          this.setState(() {
                            menuList = ApiService.getMenu(widget.cafeteriaId);
                          });
                          setState(() {
                            filteringMenus();
                          });
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Row의 크기를 자식 크기에 맞춤
                          children: [
                            Text(
                              "메뉴 등록하기",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    selectedCategory = null;
                    menuNameController.clear();
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    if (filteredMenus.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('에러'),
                          content:
                              const Text('없는 메뉴입니다. 아래 메뉴 등록하기를 눌러 메뉴를 등록해주세요'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('확인'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (menuNameController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('에러'),
                          content: const Text('메뉴를 선택해주세요'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('확인'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      // 메뉴 등록 로직 추가
                      print(
                          "$selectedCategory 카테고리, 메뉴명: ${menuNameController.text}");

                      if (weekMenus[selectedDay]!.isNotEmpty) {
                        registeringOneMenuInDiets(menuNameController.text);
                      } else {
                        registeringDiets();
                      }
                      weekMenus[selectedDay]!.add(menuNameController.text);
                      selectedCategory = null;
                      menuNameController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("등록"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> loadDiets() async {
    // await initDietList();
    Diet? todayDiets = await ApiService.getDiets(
        selectedDay, selectedMeals, widget.cafeteriaId);

    if (todayDiets != null) {
      weekMenus[selectedDay] = todayDiets.names;
      operationalDays[selectedDay] = todayDiets.dayOff;
    }
    // print('weekDiets : loadMenus : $selectedDay $weekMenus');
  }

  void showBulkAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("메뉴 일괄등록"),
              content: SingleChildScrollView(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 500, // 가로 크기를 늘림
                  height: isExpanded ? 800 : 600, // 클릭에 따라 높이를 조정
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '오늘 날짜: ${dateFormat.format(now)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _selectedDay,
                        calendarFormat: CalendarFormat.month,
                        selectedDayPredicate: (day) {
                          return selectedDates.contains(day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = focusedDay;
                            if (selectedDates.contains(selectedDay)) {
                              selectedDates.remove(selectedDay);
                            } else {
                              selectedDates.add(selectedDay);
                            }
                          });
                        },
                        calendarStyle: const CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFFFFB800),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: FutureBuilder(
                            future: ApiService.getDiets(dateFormat.format(now),
                                selectedMeals, widget.cafeteriaId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!.names;

                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final item = data[index];
                                    return CheckboxListTile(
                                      title: Text(item),
                                      value:
                                          selectedMenusForBulk.contains(item),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedMenusForBulk.add(item);
                                          } else {
                                            selectedMenusForBulk.remove(item);
                                          }
                                        });
                                      },
                                    );
                                  },
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return const Center(
                                  child: Text("해당 날짜에 등록된 식단이 없습니다."));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () async {
                    registerMultiMenuInDiets();
                    Navigator.pop(context);
                  },
                  child: const Text("등록"),
                ),
              ],
            );
          },
        );
      },
    );
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
      body: SingleChildScrollView(
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
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    '주간 식단 등록/수정',
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
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                value: selectedItem, // 현재 선택된 항목
                icon: const Icon(Icons.arrow_drop_down_sharp), // 아래 화살표 아이콘
                iconSize: 24,
                elevation: 20,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black), // 텍스트 스타일
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String? newValue) async {
                  if (newValue == "중식") {
                    selectedMeals = "LUNCH";
                  }
                  if (newValue == "조식") {
                    selectedMeals = "BREAKFAST";
                  }
                  selectedItem = newValue; // 선택된 항목을 상태로 저장
                  await initDietList();
                  await loadDiets();
                  setState(() {});
                },
                items: widget.mealList // 선택 가능한 항목 리스트
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.cafeteriaName} $selectedItem',
                          style: const TextStyle(
                            color: Color(0xFF282828),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: AutoSizeText(
                            dateFormat.format(now),
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            minFontSize: 5,
                            maxLines: 1,
                          ),
                        ),
                        const Spacer(),
                        FutureBuilder(
                          future: loadDiets(),
                          builder: (context, snapshot) => Checkbox(
                            activeColor: Colors.blue,
                            value: operationalDays[selectedDay] ?? false,
                            onChanged: (bool? value) async {
                              try {
                                await ApiService.patchDayOffStatus(
                                    widget.cafeteriaId,
                                    selectedDay,
                                    selectedMeals);
                                setState(() {
                                  operationalDays[selectedDay] = value;
                                });
                              } on Exception catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('에러'),
                                    content: Text(e.toString()),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('확인'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const Text('미운영'),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // TODO : 미입력, 미운영 날짜 표기해주면 좋을듯
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
                          selectedDay = dateFormat.format(now);
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
                    FutureBuilder<void>(
                      future: loadDiets(), // 미리 정의한 비동기 함수
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 데이터 로딩 중인 경우
                          return const CircularProgressIndicator(); // 로딩 인디케이터 표시
                        } else if (snapshot.hasError) {
                          // 에러 발생 시
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // 데이터 로딩 완료
                          return Container(
                            decoration: operationalDays[selectedDay] ?? false
                                ? null
                                : const BoxDecoration(), // 배경 조건에 따른 처리
                            foregroundDecoration:
                                operationalDays[selectedDay] ?? false
                                    ? const BoxDecoration(
                                        color: Colors.grey,
                                        backgroundBlendMode:
                                            BlendMode.saturation,
                                      )
                                    : null,
                            child: AbsorbPointer(
                              absorbing: operationalDays[selectedDay] ?? false,
                              child: Column(
                                children: [
                                  isLoading
                                      ? buildLoadingScreen()
                                      : ListView.builder(
                                          itemCount:
                                              weekMenus[selectedDay]?.length ??
                                                  0,
                                          itemBuilder: (context, index) {
                                            String menu =
                                                weekMenus[selectedDay]![index];
                                            return Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  height: 50,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        menu,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF5A5A5A),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            removeOneMenuInDiets(
                                                                menu);
                                                            loadDiets();
                                                          },
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            size: 30,
                                                            color: Color(
                                                                0xFFFFB800),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            );
                                          },
                                          shrinkWrap: true, // 여기에 추가
                                          physics:
                                              const ClampingScrollPhysics(), // 스크롤 동작을 추가로 제어할 수 있음
                                        ),
                                  Container(
                                    decoration: BoxDecoration(
                                      // color: const Color(0xFFD9D9D9),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Theme.of(context).cardColor,
                                        width: 3,
                                      ),
                                    ),
                                    height: 50,
                                    child: TextButton(
                                      //TODO: 금주 식단 등록 추가 버튼 구현
                                      onPressed: () => showDietAddDialog(),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                          Text(
                                            '추가',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).canvasColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: weekMenus[selectedDay]?.isEmpty ??
                                              true
                                          ? Colors.grey
                                          : const Color(0xffffb800),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (weekMenus[selectedDay]?.isEmpty ??
                                            true) {
                                          Fluttertoast.showToast(
                                              msg: "메뉴를 먼저 등록해주세요",
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  const Color(0xff6E6E6E),
                                              fontSize: 15,
                                              toastLength: Toast.LENGTH_SHORT);
                                        } else {
                                          showBulkAddDialog(); // 일괄등록 다이얼로그를 띄우는 함수 호출
                                        }
                                      },
                                      child: const Text(
                                        '일괄등록',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
