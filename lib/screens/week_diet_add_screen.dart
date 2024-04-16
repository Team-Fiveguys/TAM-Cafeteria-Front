import 'package:flutter/material.dart';

class WeekDiet extends StatefulWidget {
  const WeekDiet({super.key});

  @override
  _WeekDietState createState() => _WeekDietState();
}

class _WeekDietState extends State<WeekDiet> {
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

  List<String> allMenus = ['김치찌개', '국밥', '밥', '찌개'];
  List<String> filteredMenus = [];
  String? searchText = '';

  @override
  void initState() {
    super.initState();
    filteredMenus = allMenus;
    for (String day in daysOfWeek) {
      weekMenus[day] = [];
      operationalDays[day] = true; // 기본적으로 모든 요일을 운영으로 설정
    }
  }

  void filterMenus(String query) {
    final results = allMenus
        .where((menu) => menu.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredMenus = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('금주의 식단 등록'),
      ),
      body: ListView.builder(
        itemCount: daysOfWeek.length,
        itemBuilder: (context, index) {
          String day = daysOfWeek[index];
          return ListTile(
            title: Text(day),
            subtitle: Column(
              children: [
                CheckboxListTile(
                  title: const Text('미운영'),
                  value: operationalDays[day] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      operationalDays[day] = value;
                    });
                  },
                ),
                for (String menu in List.from(weekMenus[day]!))
                  Row(
                    children: [
                      Text(menu),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            setState(() => weekMenus[day]!.remove(menu)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // 메뉴 수정 로직 구현
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                            filterMenus(searchText!);
                          });
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              weekMenus[day]!.add(value);
                              allMenus.add(value);
                              searchText = '';
                            });
                          }
                        },
                      ),
                    ),
                    if (searchText != "")
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true, // 스크롤 내부에 ListView를 사용할 때 필요
                          itemCount: filteredMenus.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(filteredMenus[index]),
                              onTap: () {
                                setState(() {
                                  weekMenus[day]!.add(filteredMenus[index]);
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 식단 등록 완료 로직 구현
          print('식단 등록 완료');
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
