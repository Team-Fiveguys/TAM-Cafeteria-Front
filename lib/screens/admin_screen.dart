import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final String serverWaitingStatus = '여유';
  String? selectedItem = '명진당';
  String? currentWaitingStatus = '여유';
  int? currentWaitingTime = 5;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

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

  void postImage() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(36),
            color: Theme.of(context).canvasColor,
          ),
          width: 350,
          height: 56,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '대기열 관리',
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
        const SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            "현재 : $currentWaitingStatus ($currentWaitingTime분)",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentWaitingStatus = '여유';
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) {
                        Color borderColor = Colors.transparent; // 초기 테두리 색상
                        if (currentWaitingStatus == '여유') {
                          borderColor =
                              Theme.of(context).cardColor; // 버튼이 눌렸을 때의 테두리 색상
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: borderColor, width: 3), // 테두리 색상 적용
                        );
                      }),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('여유'),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: Image.asset(
                            'assets/images/easy.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentWaitingStatus = '보통';
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) {
                        Color borderColor = Colors.transparent; // 초기 테두리 색상
                        if (currentWaitingStatus == '보통') {
                          borderColor =
                              Theme.of(context).cardColor; // 버튼이 눌렸을 때의 테두리 색상
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: borderColor, width: 3), // 테두리 색상 적용
                        );
                      }),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('보통'),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: Image.asset(
                            'assets/images/normal.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentWaitingStatus = '혼잡';
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) {
                        Color borderColor = Colors.transparent; // 초기 테두리 색상
                        if (currentWaitingStatus == '혼잡') {
                          borderColor =
                              Theme.of(context).cardColor; // 버튼이 눌렸을 때의 테두리 색상
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: borderColor, width: 3), // 테두리 색상 적용
                        );
                      }),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('혼잡'),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: Image.asset(
                            'assets/images/busy.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentWaitingStatus = '매우 혼잡';
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) {
                        Color borderColor = Colors.transparent; // 초기 테두리 색상
                        if (currentWaitingStatus == '매우 혼잡') {
                          borderColor =
                              Theme.of(context).cardColor; // 버튼이 눌렸을 때의 테두리 색상
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: borderColor, width: 3), // 테두리 색상 적용
                        );
                      }),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('매우 혼잡'),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 60,
                          height: 40,
                          child: Image.asset(
                            'assets/images/veryBusy.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(36),
            color: Theme.of(context).canvasColor,
          ),
          width: 350,
          height: 56,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '식단 관리',
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
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => _showImagePicker(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                ),
                height: 100,
                child: const Center(
                    child: Text(
                  "메뉴 사진 \n등록",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                ),
                height: 100,
                child: const Center(
                  child: Text(
                    "금주 식단 \n등록 수정",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
