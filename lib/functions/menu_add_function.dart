import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

Future<void> showMenuInput(
    BuildContext context, StateSetter beforeSetState) async {
  String? selectedCategory; // 선택된 카테고리를 저장할 변수
  final TextEditingController menuNameController = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (context) {
      // StatefulBuilder를 사용하여 AlertDialog 내부에서 상태 관리
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("메뉴 입력"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text("카테고리 선택"),
                    value: selectedCategory,
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      // StatefulBuilder의 setState를 사용
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
                    decoration: const InputDecoration(
                      hintText: "메뉴 명",
                    ),
                  ),
                ],
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
                onPressed: () async {
                  // 여기에 메뉴 등록 로직 추가
                  print(
                      "$selectedCategory 카테고리, 메뉴명: ${menuNameController.text}");
                  await ApiService.postMenu(menuNameController.text);
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
