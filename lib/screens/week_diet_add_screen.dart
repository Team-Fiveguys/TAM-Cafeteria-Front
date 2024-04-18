import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/functions/menu_add_function.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class WeekDiet extends StatefulWidget {
  const WeekDiet({
    super.key,
    required this.cafeteriaName,
  });
  final String cafeteriaName;
  @override
  State<WeekDiet> createState() => _WeekDietState();
}

class _WeekDietState extends State<WeekDiet> {
  late Future<List<String>> menuList;
  List<String> filteredMenus = [];

  DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy / MM / dd');

  String? selectedItem = '중식';

  final List<String> daysOfWeek = [
    '월요일',
    '화요일',
    '수요일',
    '목요일',
    '금요일',
    '토요일',
    '일요일'
  ];
  Map<String, List<String>> weekMenus = {};
  Map<String, bool?> operationalDays = {};
  String? searchText;
  String? selectedDay;
  int selectedDayIndex = DateTime.now().weekday - 1;

  String? selectedCategory; // 선택된 카테고리를 저장할 변수
  final TextEditingController menuNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    menuList = ApiService.getMenu();
    menuNameController.addListener(filteringMenus);
    selectedDay = daysOfWeek[DateTime.now().weekday - 1];
    for (String day in daysOfWeek) {
      weekMenus[day] = [];
      operationalDays[day] = true; // 기본적으로 모든 요일을 운영으로 설정
    }
  }

  Future<void> filteringMenus() async {
    // 비동기 함수로 변경
    String query = menuNameController.text;
    List<String> menuListResult = await menuList; // await를 사용하여 비동기 처리
    setState(() {
      filteredMenus = menuListResult
          .where((menu) => menu.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

// 선택된 요일을 기반으로 날짜를 업데이트하는 함수
  void updateDateForSelectedDay(String? selectedDay) {
    selectedDayIndex = daysOfWeek.indexOf(selectedDay!);
    int currentDayIndex =
        DateTime.now().weekday - 1; // DateTime에서 요일은 1부터 시작 (월요일 = 1)

    // 선택된 요일과 현재 요일의 차이를 계산합니다.
    int difference = selectedDayIndex - currentDayIndex;

    // 현재 날짜에서 차이만큼 더하거나 빼서 새로운 날짜를 계산합니다.
    DateTime newDate = DateTime.now().add(Duration(days: difference));

    // 상태를 업데이트합니다. 여기서는 예시로 상태 업데이트 방법을 단순화했습니다.
    // Flutter에서는 setState()를 사용하여 상태를 업데이트해야 합니다.
    setState(() {
      selectedDay = daysOfWeek[selectedDayIndex]; // 선택된 요일을 업데이트
      now = newDate; // now 변수를 새로운 날짜로 업데이트
    });
  }

  void showDietAddDialog() {
    showDialog(
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
                      DropdownButton<String>(
                        hint: const Text("카테고리 선택"),
                        value: selectedCategory,
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: <String>['한식', '중식', '일식', '양식']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
                        child: FutureBuilder<List<String>>(
                          future: menuList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: menuNameController.text.isEmpty
                                    ? snapshot.data!.length
                                    : filteredMenus.length,
                                itemBuilder: (context, index) {
                                  final item = menuNameController.text.isEmpty
                                      ? snapshot.data![index]
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
                        onPressed: () => showMenuInput(context),
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
                    // 메뉴 등록 로직 추가
                    print(
                        "$selectedCategory 카테고리, 메뉴명: ${menuNameController.text}");
                    weekMenus[selectedDay!]!.add(menuNameController.text);
                    selectedCategory = null;
                    menuNameController.clear();
                    Navigator.of(context).pop();
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
    print(weekMenus[selectedDay]!.length);
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
      body: Column(
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
                  '금주 식단 등록/수정',
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
              onChanged: (String? newValue) {
                setState(() {
                  selectedItem = newValue; // 선택된 항목을 상태로 저장
                });
              },
              items: <String>[
                '중식',
                '조식',
              ] // 선택 가능한 항목 리스트
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              child: SingleChildScrollView(
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
                        Checkbox(
                          activeColor: Colors.blue,
                          value:
                              operationalDays[daysOfWeek[selectedDayIndex]] ??
                                  false,
                          onChanged: (bool? value) {
                            setState(() {
                              operationalDays[daysOfWeek[selectedDayIndex]] =
                                  value;
                            });
                          },
                        ),
                        const Text('미운영'),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.topCenter,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        value: selectedDay, // 현재 선택된 항목
                        icon: const Icon(
                            Icons.arrow_drop_down_sharp), // 아래 화살표 아이콘
                        iconSize: 24,
                        elevation: 20,
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black), // 텍스트 스타일
                        underline: Container(
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDay = newValue; // 선택된 항목을 상태로 저장
                          });
                        },
                        items: daysOfWeek
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                            onTap: () => updateDateForSelectedDay(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        for (var menu in weekMenus[selectedDay]!)
                          Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Theme.of(context).canvasColor,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      menu,
                                      style: const TextStyle(
                                        color: Color(0xFF5A5A5A),
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 30,
                                          color: Color(0xFFFFB800),
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 50,
                      child: TextButton(
                        //TODO: 금주 식단 등록 추가 버튼 구현
                        onPressed: () => showDietAddDialog(),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Color(0xFF5A5A5A),
                            ),
                            Text(
                              '추가',
                              style: TextStyle(
                                color: Color(0xFF5A5A5A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
