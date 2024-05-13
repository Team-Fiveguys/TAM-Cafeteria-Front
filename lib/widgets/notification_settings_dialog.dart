import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool allAlarm = false;
  late bool myeongjinAlarm;
  late bool myeongDonAlarm;
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
    // initializeSettings();
  }

  // 서버에서 받은 설정으로 초기화
  // 서버에서 받은 설정으로 초기화
// 서버에서 받은 설정으로 초기화
  Future<void> initializeSettings() async {
    // 서버에서 받은 설정 데이터. 예시로 하드코딩했으나 실제로는 ApiService를 사용하여 가져와야 합니다.
    final settings = await ApiService.getNotificationSettings();
    if (settings.isNotEmpty) {
      myeongjinAlarm = settings['myeongJin'] ?? false;
      hakgwanAlarm = settings['hakGwan'] ?? false;
      myeongDonAlarm = settings['myeongDon'] ?? false;
      todaydietAlarm = settings['todayDiet'] ?? false;
      dietphotoenrollAlarm = settings['dietPhotoEnroll'] ?? false;
      weekdietenrollAlarm = settings['weekDietEnroll'] ?? false;
      dietsoldoutAlarm = settings['dietSoldOut'] ?? false;
      dietchangeAlarm = settings['dietChange'] ?? false;
      allAlarm = myeongjinAlarm ||
          hakgwanAlarm ||
          myeongDonAlarm ||
          todaydietAlarm ||
          dietphotoenrollAlarm ||
          weekdietenrollAlarm ||
          dietsoldoutAlarm ||
          dietchangeAlarm;
    }
  }

  Future<void> saveSettings(BuildContext context) async {
    // 로딩 인디케이터 시작
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("저장 중..."),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      Map<String, bool> newSettings = {
        'hakGwan': hakgwanAlarm,
        'myeongJin': myeongjinAlarm,
        'myeongDon': myeongDonAlarm,
        'todayDiet': todaydietAlarm,
        'dietPhotoEnroll': dietphotoenrollAlarm,
        'weekDietEnroll': weekdietenrollAlarm,
        'dietSoldOut': dietsoldoutAlarm,
        'dietChange': dietchangeAlarm,
      };
      // 변경된 설정을 서버에 저장하는 작업을 시작
      await Future.wait([
        ApiService.updateNotificationSettings(newSettings),
        // if (hakgwanAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('hakGwan')
        // else
        //   Future.value(),
        // if (!hakgwanAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('hakGwan')
        // else
        //   Future.value(),
        // if (myeongjinAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('myeongJin')
        // else
        //   Future.value(),
        // if (!myeongjinAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('myeongJin')
        // else
        //   Future.value(),
        // if (myeongDonAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('myeongDon')
        // else
        //   Future.value(),
        // if (!myeongDonAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('myeongDon')
        // else
        //   Future.value(),
        // if (todaydietAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('todayDiet')
        // else
        //   Future.value(),
        // if (!todaydietAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('todayDiet')
        // else
        //   Future.value(),
        // if (dietphotoenrollAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('dietPhotoEnroll')
        // else
        //   Future.value(),
        // if (!dietphotoenrollAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('dietPhotoEnroll')
        // else
        //   Future.value(),
        // if (weekdietenrollAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('weekDietEnroll')
        // else
        //   Future.value(),
        // if (!weekdietenrollAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('weekDietEnroll')
        // else
        //   Future.value(),
        // if (dietsoldoutAlarm)
        //   FirebaseMessaging.instance.subscribeToTopic('dietSoldOut')
        // else
        //   Future.value(),
        // if (!dietsoldoutAlarm)
        //   FirebaseMessaging.instance.unsubscribeFromTopic('dietSoldOut')
        // else
        //   Future.value(),
        // // 다른 FCM 구독/구독 해제 로직을 여기에 포함시킵니다.
      ]).timeout(const Duration(seconds: 10));
      // 로딩 인디케이터 종료
      Navigator.of(context).pop();

      // 저장 완료 메시지 출력 또는 다른 처리
      print("Notification settings saved successfully.");
    } catch (e) {
      // 로딩 인디케이터 종료
      Navigator.of(context).pop();

      // 에러 메시지 출력 또는 에러 다이얼로그 띄우기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("에러"),
            content: const Text("알림 설정을 저장하는 데 실패했습니다. 다시 시도해주세요."),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
              builder: (ctx) {
                return FutureBuilder(
                  future: initializeSettings(),
                  builder: (futureContext, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      // 에러 발생 시
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return StatefulBuilder(
                        builder: (BuildContext context_, StateSetter setState) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.buttonText,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context_).pop();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '전체 알림',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: allAlarm,
                                      onChanged: (value) {
                                        setState(() {
                                          allAlarm = value;
                                          // 전체 알림 스위치 상태가 변경될 때 각 알림 항목 스위치도 동일하게 변경
                                          myeongjinAlarm = value;
                                          hakgwanAlarm = value;
                                          myeongDonAlarm = value;
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('명돈이네'),
                                    Switch(
                                      value: myeongDonAlarm,
                                      onChanged: (value) {
                                        setState(() {
                                          myeongDonAlarm = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '기능 알림',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text('식단 변경'),
                                //     Switch(
                                //       value: dietchangeAlarm,
                                //       onChanged: (value) {
                                //         setState(() {
                                //           dietchangeAlarm = value;
                                //         });
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  // 변경된 알림 설정을 저장
                                  saveSettings(context_).then(
                                      (value) => Navigator.of(context_).pop());
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
                    }
                  },
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
