import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/models/notification_model.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({super.key});

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  Future<List<NotificationModel>> notificationList =
      ApiService.getNotifications();

  void deleteNotification(String id) async {
    await ApiService.deleteOneNotification(id);
  }

  Future<void> deleteAllNotification() async {
    await ApiService.deleteAllNotification();
  }

  void readNotification(NotificationModel notification) async {
    await ApiService.readOneNotification(notification.id.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification.title),
          content: SingleChildScrollView(child: Text(notification.content)),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notificationList = ApiService.getNotifications();
                });
                Navigator.of(context).pop();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void readAllNoti() async {
    await ApiService.readAllNotification();
    setState(() {
      notificationList = ApiService.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 3,
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
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  '알림',
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
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    readAllNoti();
                  },
                  child: Text(
                    '전부 읽기',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await deleteAllNotification();
                    setState(() {
                      notificationList = ApiService.getNotifications();
                    });
                  },
                  child: Text(
                    '전부 삭제',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: notificationList,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    List<NotificationModel> data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length, // 알림의 개수
                      itemBuilder: (BuildContext context, int index) {
                        // Dismissible 위젯을 사용해 스와이프로 삭제할 수 있게 함
                        return Dismissible(
                          key: Key('$index'), // 각 Dismissible 위젯에 고유한 키를 제공
                          onDismissed: (direction) {
                            deleteNotification(data[index].id.toString());
                            // 여기서 실제 데이터 삭제 로직을 구현해야 함
                            // 예를 들어, setState를 사용하여 상태를 업데이트하거나,
                            // 데이터 모델에서 해당 항목을 삭제하는 등의 작업을 수행
                          },
                          background: Container(
                            color: Colors.red, // 스와이프 시 나타날 배경색
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: data[index].isRead
                                  ? const Color(0xFFF0F0F0)
                                  : Colors.white, // 배경색
                              borderRadius: BorderRadius.circular(10), // 둥근 모서리
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // 그림자 위치 조정
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: ListTile(
                              title: Text(data[index].title),
                              subtitle: Text(data[index].content),
                              onTap: () {
                                if (!data[index].isRead) {
                                  readNotification(data[index]);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    );
  }
}
