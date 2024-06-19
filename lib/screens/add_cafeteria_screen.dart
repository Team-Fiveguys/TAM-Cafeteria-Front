import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class AddCafeteria extends StatefulWidget {
  const AddCafeteria({super.key});

  @override
  State<AddCafeteria> createState() => _AddCafeteriaState();
}

class _AddCafeteriaState extends State<AddCafeteria> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController breakfastController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  bool isRunBreakfast = false;
  bool isRunLunch = false;

  String formatTime(String input) {
    // 공백 제거
    input = input.replaceAll(' ', '');

    // HH~HH 형식을 HH:00~HH:00 형식으로 변환
    final regex = RegExp(r'^(\d{1,2})(~)(\d{1,2})$');
    if (regex.hasMatch(input)) {
      return input.replaceAllMapped(regex, (match) {
        String startHour = match.group(1)!.padLeft(2, '0');
        String endHour = match.group(3)!.padLeft(2, '0');
        return '$startHour:00~$endHour:00';
      });
    }

    // 이미 올바른 형식인 경우 반환
    return input;
  }

  void submit() async {
    String msg = "등록되었습니다";
    if (nameController.text.isEmpty) {
      msg = "식당명을 입력하세요";
    } else if (locationController.text.isEmpty) {
      msg = "위치를 입력하세요";
    } else if (!isRunBreakfast && breakfastController.text.isEmpty) {
      msg = "조식 운영시간을 입력하세요";
    } else if (!isRunLunch && lunchController.text.isEmpty) {
      msg = "중식 운영시간을 입력하세요";
    } else {
      try {
        String breakfastTime = formatTime(breakfastController.text);
        String lunchTime = formatTime(lunchController.text);
        await ApiService.postAddCafeteria(
            nameController.text,
            locationController.text,
            !isRunBreakfast,
            !isRunLunch,
            breakfastTime,
            lunchTime);
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(msg),
                ElevatedButton(
                  child: const Text('닫기'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
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
          // mainAxisSize: MainAxisSize.min,
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
                    '식당 등록',
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
              height: 50,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('* 운영시간은 공백없이 입력해주세요.*'),
                  Text('예시(HH:MM~HH:MM)')
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(15),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '식당명',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: nameController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'ex) 명진당',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '위치',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: locationController,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: 'ex) 명진당 지하1층',
                            ),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blue,
                          value: isRunBreakfast,
                          onChanged: (bool? value) async {
                            setState(() {
                              isRunBreakfast = value!;
                            });
                          },
                        ),
                        const Text('조식 미운영'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '조식 운영시간',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: breakfastController,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: 'ex) 08:00~10:00',
                            ),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blue,
                          value: isRunLunch,
                          onChanged: (bool? value) async {
                            setState(() {
                              isRunLunch = value!;
                            });
                          },
                        ),
                        const Text('중식 미운영'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '중식 운영시간',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: lunchController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'ex) 11:30~14:30',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFB800),
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                  onPressed: () => submit(),
                  child: const Text(
                    "등록",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
