import 'package:flutter/material.dart';

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

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
                    Navigator.pop(context);
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
                    // 전부 읽기 로직 구현
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
                  onPressed: () {
                    // 전부 삭제 로직 구현
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
            child: ListView.builder(
              itemCount: 10, // 알림의 개수
              itemBuilder: (BuildContext context, int index) {
                // Dismissible 위젯을 사용해 스와이프로 삭제할 수 있게 함
                return Dismissible(
                  key: Key('$index'), // 각 Dismissible 위젯에 고유한 키를 제공
                  onDismissed: (direction) {
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
                      color: Colors.white, // 배경색
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: ListTile(
                      title: Text('알림 제목 $index'),
                      subtitle: Text('알림 내용 $index'),
                      // 여기에 추가적인 동작을 구현할 수 있음
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
