import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationSendPage extends StatefulWidget {
  const NotificationSendPage({super.key});

  @override
  State<NotificationSendPage> createState() => _NotificationSendPageState();
}

class _NotificationSendPageState extends State<NotificationSendPage> {
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
                      // if(initMenuListLength) TODO: 추가한 메뉴가 있을때 확인알림 해줘야할듯?
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'PUSH 알림 보내기',
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                children: [
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
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: const Center(
                                  child: Text(
                                "금주 식단\n 등록 완료",
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
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: const Center(
                                child: Text(
                                  "금주 식단\n수정 완료",
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
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "직접 알림\n보내기",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}