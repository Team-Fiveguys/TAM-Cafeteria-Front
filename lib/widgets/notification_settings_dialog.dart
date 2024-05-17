import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool myeongjinAlarm = false;
  bool myeongDonAlarm = false;
  bool hakgwanAlarm = false;
  bool todaydietAlarm = false;
  bool dietphotoenrollAlarm = false;
  bool weekdietenrollAlarm = false;
  bool dietsoldoutAlarm = false;
  bool generalAlarm = false;

  @override
  void initState() {
    super.initState();
    // 초기 설정을 서버에서 받은 값으로 초기화
    // initializeSettings();
  }

// 서버에서 받은 설정으로 초기화
  Future<void> initializeSettings() async {
    print(
        "initializeSetting : isDenied=${await Permission.notification.isDenied}  isProvisional=${await Permission.notification.isProvisional} ");
    if (!await Permission.notification.isGranted) {
      print('니녀석이냐?');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('알림'),
          content: const Text('알림을 허용하지 않은 사용자입니다. 알림을 받기 위해 알림 설정으로 이동해주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('이동'),
              onPressed: () {
                Navigator.of(ctx).pop();
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

      return;
      // await Permission.notification.request();
    }
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String, bool> hasSetting = await ApiService.getNotificationSettings();

    if (fcmToken != null) {
      if (hasSetting.isEmpty) {
        await ApiService.postNotificationSet(fcmToken);
        hasSetting = await ApiService.getNotificationSettings();
        // await ApiService.updateNotificationSettings(hasSetting);
      } else if (fcmToken != await ApiService.getRegistrationToken()) {
        await ApiService.putRegistrationToken(fcmToken);
        // await ApiService.updateNotificationSettings(hasSetting);
      }
      if (hasSetting.isNotEmpty) {
        myeongjinAlarm = hasSetting['myeongJin'] ?? false;
        hakgwanAlarm = hasSetting['hakGwan'] ?? false;
        myeongDonAlarm = hasSetting['myeongDon'] ?? false;
        todaydietAlarm = hasSetting['todayDiet'] ?? false;
        dietphotoenrollAlarm = hasSetting['dietPhotoEnroll'] ?? false;
        weekdietenrollAlarm = hasSetting['weekDietEnroll'] ?? false;
        dietsoldoutAlarm = hasSetting['dietSoldOut'] ?? false;
        generalAlarm = hasSetting['general'] ?? false;
        allAlarm = myeongjinAlarm ||
            hakgwanAlarm ||
            myeongDonAlarm ||
            todaydietAlarm ||
            dietphotoenrollAlarm ||
            weekdietenrollAlarm ||
            dietsoldoutAlarm ||
            generalAlarm;
      }
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
        'general': generalAlarm,
        'hakGwan': hakgwanAlarm,
        'myeongJin': myeongjinAlarm,
        'myeongDon': myeongDonAlarm,
        'todayDiet': todaydietAlarm,
        'dietPhotoEnroll': dietphotoenrollAlarm,
        'weekDietEnroll': weekdietenrollAlarm,
        'dietSoldOut': dietsoldoutAlarm,
      };
      // 변경된 설정을 서버에 저장하는 작업을 시작
      await Future.wait([
        ApiService.updateNotificationSettings(newSettings),
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
              barrierDismissible: false,
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
                            content: SingleChildScrollView(
                              child: Column(
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
                                            generalAlarm = value;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
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
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('일반 알림'),
                                      Switch(
                                        value: generalAlarm,
                                        onChanged: (value) {
                                          setState(() {
                                            generalAlarm = value;
                                            allAlarm = myeongjinAlarm ||
                                                hakgwanAlarm ||
                                                myeongDonAlarm ||
                                                todaydietAlarm ||
                                                dietphotoenrollAlarm ||
                                                weekdietenrollAlarm ||
                                                dietsoldoutAlarm ||
                                                generalAlarm;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).canvasColor)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.buttonText,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
