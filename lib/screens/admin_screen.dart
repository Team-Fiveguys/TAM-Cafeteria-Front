import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/screens/week_diet_add_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:tam_cafeteria_front/widgets/waiting_indicator_widget.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy / MM / dd');

  final String serverWaitingStatus = '여유';
  String? selectedItem = '명진당';
  String currentWaitingStatus = '선택 안함';
  int? currentWaitingTime = 5;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  String? selectedCategory; // 선택된 카테고리를 저장할 변수
  final TextEditingController menuNameController = TextEditingController();

  final List<String> waitingStatusList = [
    "여유",
    "보통",
    "혼잡",
    "매우 \n혼잡",
  ];

  final List<String> waitingImageList = [
    'assets/images/easy.png',
    'assets/images/normal.png',
    'assets/images/busy.png',
    'assets/images/veryBusy.png',
  ];

  void _showImagePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("이미지 업로드"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _image != null
                    ? Image.file(File(_image!.path))
                    : Container(height: 50),
                TextButton(
                  onPressed: () async {
                    final XFile? pickedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _image = pickedImage;
                      });
                    }
                    Navigator.of(context).pop(); // 이미지를 선택한 후 팝업 창을 닫습니다.
                    _showImagePicker(); // 선택한 이미지를 반영하기 위해 다시 팝업 창을 엽니다.
                  },
                  child: const Text("이미지 선택"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                if (_image != null) {
                  ApiService.postDietPhoto(_image!);
                }
                // 이미지 업로드 로직 추가
                Navigator.of(context).pop();
              },
              child: const Text("등록"),
            ),
          ],
        );
      },
    );
  }

  void showMenuInput() {
    showDialog(
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
                  onPressed: () {
                    // 여기에 메뉴 등록 로직 추가
                    print(
                        "$selectedCategory 카테고리, 메뉴명: ${menuNameController.text}");
                    ApiService.postMenu(menuNameController.text);
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
    return Column(
      children: [
        //관리자 페이지
        Container(
          alignment: Alignment.center,
          // width: 350,
          height: 56,
          color: Theme.of(context).canvasColor,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '관리자 페이지',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        //명진당 (식당 선택 리스트)
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
              print('$selectedItem');
            },
            items: <String>[
              '명진당',
              '학생회관',
            ] // 선택 가능한 항목 리스트
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        //대기열 관리
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 30,
          ),
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
                width: 360,
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '대기열 관리',
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('현재 상태 - $currentWaitingStatus')
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < 4; i++)
                            WaitingIndicator(
                              imageUrl: waitingImageList[i],
                              waitingStatus: waitingStatusList[i],
                              currentStatus: currentWaitingStatus,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              //메뉴 변동
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
                width: 360,
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '메뉴 변동',
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            dateFormat.format(now),
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              //식수 관리
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
                width: 360,
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '식수 관리',
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF999999),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 130,
                              child: const Column(
                                children: [
                                  Text(
                                    '예상 식수',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF999999),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 130,
                              child: const Column(
                                children: [
                                  Text(
                                    '실제 식수',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
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
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        child: TextButton(
                          onPressed: () => _showImagePicker(),
                          child: const Center(
                              child: Text(
                            "메뉴 사진 \n등록",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
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
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WeekDiet(),
                              ),
                            );
                          },
                          child: const Center(
                            child: Text(
                              "금주 식단 \n등록 수정",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF282828),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
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
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        child: TextButton(
                          onPressed: () => showMenuInput(),
                          child: const Center(
                              child: Text(
                            "메뉴 입력",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
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
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const Center(
                            child: Text(
                              "PUSH\n알림 보내기",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF282828),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
