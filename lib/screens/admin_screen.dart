import 'dart:io';
import 'package:tam_cafeteria_front/models/menu_model.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/functions/menu_add_function.dart';
import 'package:tam_cafeteria_front/screens/notification_send_screen.dart';
import 'package:tam_cafeteria_front/screens/week_diet_add_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:tam_cafeteria_front/widgets/waiting_indicator_widget.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  int cafateriaId = 1;
  String serverWaitingStatus = '여유';
  String? selectedItem = '명진당';
  String currentWaitingStatus = '선택 안함';
  int? currentWaitingTime = 5;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  final List<String> menuList = [
    "마제소바",
    "도토리묵야채무침calclalcal",
    "타코야끼",
    "락교",
    "요구르트",
    "아이스믹스커피",
    "배추김치&추가밥",
  ];

  late String cafeteriaName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (selectedItem != null) {
      cafeteriaName = selectedItem!;
    }
    print('admin initState');
  }

  final List<String> waitingStatusList = [
    "여유",
    "보통",
    "혼잡",
    "매우혼잡",
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
                  ApiService.postDietPhoto(
                      _image!, dateFormat.format(now), "LUNCH", cafateriaId);
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

  void updateCurrentStatus(String newStatus) {
    setState(() {
      currentWaitingStatus = newStatus;
    });
  }

  Future<void> getCongestionStatus() async {
    serverWaitingStatus = await ApiService.getCongestionStatus(cafateriaId);
    currentWaitingStatus = serverWaitingStatus;
    print(currentWaitingStatus);
  }

  @override
  Widget build(BuildContext context) {
    print("admin screen : build");
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
                height: 220,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: FutureBuilder(
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
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    Expanded(
                                      child: AutoSizeText(
                                        '현재 상태 - $currentWaitingStatus',
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                        minFontSize: 10,
                                        maxLines: 2,
                                      ),
                                    ),
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
                                        cafeteriaId: cafateriaId,
                                        onStatusChanged: updateCurrentStatus,
                                      ),
                                  ],
                                ),
                              ],
                            );
                          }
                        })),
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
                          const SizedBox(
                            width: 140,
                          ),
                          //그냥 수정페이지로 갈수 있게?
                          Text(
                            dateFormat.format(now),
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text('메뉴수정'),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).canvasColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(
                            children: [
                              const Flexible(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    '조식',
                                    style: TextStyle(
                                      color: Color(0xFF5A5A5A),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: FutureBuilder<List<String>>(
                                    future: ApiService.getTodayLunchMenu(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // 데이터를 기다리는 동안 로딩 표시를 표시합니다.
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        // 에러가 발생한 경우 에러 메시지를 표시합니다.
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        // 데이터를 성공적으로 불러온 경우 메뉴 항목을 그리드 뷰로 표시합니다.
                                        return GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // 한 줄에 표시할 아이템의 수를 2로 설정합니다.
                                            childAspectRatio:
                                                3, // 아이템의 가로 세로 비율을 조정합니다.
                                          ),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 0),
                                              child: Text(
                                                '.${snapshot.data![index]}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).canvasColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(
                            children: [
                              const Flexible(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    '중식',
                                    style: TextStyle(
                                      color: Color(0xFF5A5A5A),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: FutureBuilder<List<String>>(
                                    future: ApiService.getTodayLunchMenu(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // 데이터를 기다리는 동안 로딩 표시를 표시합니다.
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        // 에러가 발생한 경우 에러 메시지를 표시합니다.
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        // 데이터를 성공적으로 불러온 경우 메뉴 항목을 그리드 뷰로 표시합니다.
                                        return GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // 한 줄에 표시할 아이템의 수를 2로 설정합니다.
                                            childAspectRatio:
                                                3, // 아이템의 가로 세로 비율을 조정합니다.
                                          ),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 0),
                                              child: Text(
                                                '.${snapshot.data![index]}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
                            ),
                          ),
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
                                builder: (context) => WeekDiet(
                                  cafeteriaName: cafeteriaName,
                                  cafeteriaId: cafateriaId,
                                ),
                              ),
                            );
                          },
                          child: const Center(
                            child: Text(
                              "주간 식단 \n등록 수정",
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
                          onPressed: () =>
                              showMenuInput(context, setState, cafateriaId),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationSendPage(
                                  cafeteriaId: cafateriaId,
                                ),
                              ),
                            );
                          },
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
                          onPressed: () {},
                          child: const Center(
                              child: Text(
                            "식당 등록",
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
                              "유저 관리",
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
                width: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
