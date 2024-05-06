import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class NotificationSettingsDialog extends StatefulWidget {
  final String buttonText;

  const NotificationSettingsDialog({Key? key, required this.buttonText})
      : super(key: key);

  @override
  _NotificationSettingsDialogState createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  late bool allAlarm;
  late bool myeongjinAlarm;
  late bool hakgwanAlarm;
  late bool todaydietAlarm;
  late bool dietphotoenrollAlarm;
  late bool weekdietenrollAlarm;
  late bool dietsoldoutAlarm;
  late bool dietchangeAlarm;

  @override
  void initState() {
    super.initState();
    // 초기 설정을 서버에서 받은 값으로 초기화
    initializeSettings();
  }

  // 서버에서 받은 설정으로 초기화
  // 서버에서 받은 설정으로 초기화
// 서버에서 받은 설정으로 초기화
  void initializeSettings() {
    // 서버에서 받은 설정 데이터. 예시로 하드코딩했으나 실제로는 ApiService를 사용하여 가져와야 합니다.
    ApiService.fetchNotificationSettings().then((receivedSettings) {
      // 서버에서 받은 설정을 각 변수에 할당
      allAlarm = receivedSettings['allAlarm'];
      myeongjinAlarm = receivedSettings['myeongjinAlarm'];
      hakgwanAlarm = receivedSettings['hakgwanAlarm'];
      todaydietAlarm = receivedSettings['todaydietAlarm'];
      dietphotoenrollAlarm = receivedSettings['dietphotoenrollAlarm'];
      weekdietenrollAlarm = receivedSettings['weekdietenrollAlarm'];
      dietsoldoutAlarm = receivedSettings['dietsoldoutAlarm'];
      dietchangeAlarm = receivedSettings['dietchangeAlarm'];
    }).catchError((error) {
      // 에러 처리
      print("설정을 불러오는 도중 오류가 발생했습니다: $error");
    });
  }

  void saveSettings() async {
    try {
      Map<String, bool> newSettings = {
        'hakGwan': hakgwanAlarm,
        'myeongJin': myeongjinAlarm,
        'todayDiet': todaydietAlarm,
        'dietPhotoEnroll': dietphotoenrollAlarm,
        'weekDietEnroll': weekdietenrollAlarm,
        'dietSoldOut': dietsoldoutAlarm,
        'dietChange': dietchangeAlarm,
      };

      // 변경된 설정을 서버에 저장
      await ApiService.updateNotificationSettings(newSettings);

      // 저장 완료 메시지 출력
      print("Notification settings saved successfully.");
    } catch (e) {
      // 저장 실패 메시지 출력
      print("Failed to save notification settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
        ),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.buttonText,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('전체 알림'),
                          Switch(
                            value: allAlarm,
                            onChanged: (value) {
                              setState(() {
                                allAlarm = value;
                                // 전체 알림 스위치 상태가 변경될 때 각 알림 항목 스위치도 동일하게 변경
                                myeongjinAlarm = value;
                                hakgwanAlarm = value;
                                todaydietAlarm = value;
                                dietphotoenrollAlarm = value;
                                weekdietenrollAlarm = value;
                                dietsoldoutAlarm = value;
                                dietchangeAlarm = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '식당 알림',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('명진당'),
                              Switch(
                                value: myeongjinAlarm,
                                onChanged: (value) {
                                  setState(() {
                                    myeongjinAlarm = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('학생회관'),
                              Switch(
                                value: hakgwanAlarm,
                                onChanged: (value) {
                                  setState(() {
                                    hakgwanAlarm = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '기능 알림',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('오늘의 식단'),
                          Switch(
                            value: todaydietAlarm,
                            onChanged: (value) {
                              setState(() {
                                todaydietAlarm = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('식단 사진 등록'),
                          Switch(
                            value: dietphotoenrollAlarm,
                            onChanged: (value) {
                              setState(() {
                                dietphotoenrollAlarm = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('주간 식단 등록'),
                          Switch(
                            value: weekdietenrollAlarm,
                            onChanged: (value) {
                              setState(() {
                                weekdietenrollAlarm = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('품절'),
                          Switch(
                            value: dietsoldoutAlarm,
                            onChanged: (value) {
                              setState(() {
                                dietsoldoutAlarm = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('식단 변경'),
                          Switch(
                            value: dietchangeAlarm,
                            onChanged: (value) {
                              setState(() {
                                dietchangeAlarm = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // 변경된 알림 설정을 저장
                        saveSettings();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffb800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '저장',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffc6c6c6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.buttonText,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
