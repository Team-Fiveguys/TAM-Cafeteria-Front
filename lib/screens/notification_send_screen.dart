import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class NotificationSendPage extends StatefulWidget {
  const NotificationSendPage({
    super.key,
    required this.cafeteriaId,
    required this.cafeteriaName,
  });
  final int cafeteriaId;
  final String cafeteriaName;

  @override
  State<NotificationSendPage> createState() => _NotificationSendPageState();
}

class _NotificationSendPageState extends State<NotificationSendPage> {
  void pushNotification() async {
    try {
      final channel = widget.cafeteriaId == 1
          ? "myeongJin"
          : widget.cafeteriaId == 2
              ? "hakGwan"
              : widget.cafeteriaId == 3
                  ? "myeongDon"
                  : "";
      await ApiService.postNotificationToSubscriber(
          "[${widget.cafeteriaName}] 주간 식단 등록",
          "${widget.cafeteriaName} 주간 식단표가 등록되었어요. 확인해보세요!",
          channel,
          "weekDietEnroll");
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

  void showSendNotification() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    titleController.text = "[${widget.cafeteriaName}]";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("알림 작성"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "제목",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: "내용",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  maxLines: 10, // 무제한 줄 입력을 허용하거나, 원하는 줄 수를 지정할 수 있습니다.
                  keyboardType:
                      TextInputType.multiline, // 여러 줄 입력을 위해 키보드 타입 설정
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
              onPressed: () async {
                final channel = widget.cafeteriaId == 1
                    ? "myeongJin"
                    : widget.cafeteriaId == 2
                        ? "hakGwan"
                        : widget.cafeteriaId == 3
                            ? "myeongDon"
                            : "";
                try {
                  await ApiService.postNotificationToSubscriber(
                      titleController.text,
                      contentController.text,
                      channel,
                      'general');
                  Navigator.of(context).pop();
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
              },
              child: const Text("등록"),
            ),
          ],
        );
      },
    );
  }

  void showSendImportantNotification() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    // titleController.text = "[${widget.cafeteriaName}]";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("알림 작성"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "제목",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: "내용",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  maxLines: 10, // 무제한 줄 입력을 허용하거나, 원하는 줄 수를 지정할 수 있습니다.
                  keyboardType:
                      TextInputType.multiline, // 여러 줄 입력을 위해 키보드 타입 설정
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
              onPressed: () async {
                // final channel = widget.cafeteriaId == 1
                //     ? "myeongJin"
                //     : widget.cafeteriaId == 2
                //         ? "hakGwan"
                //         : widget.cafeteriaId == 3
                //             ? "myeongDon"
                //             : "";
                try {
                  await ApiService.postNotificationToAllUser(
                      titleController.text, contentController.text);
                  Navigator.of(context).pop();
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
              },
              child: const Text("등록"),
            ),
          ],
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
                mainAxisSize: MainAxisSize.min,
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
                              onPressed: pushNotification,
                              child: const Center(
                                  child: Text(
                                "주간 식단\n 등록 완료",
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
                              onPressed: showSendNotification,
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
                      child: TextButton(
                        onPressed: showSendImportantNotification,
                        child: const Center(
                          child: Text(
                            "중요 공지\n보내기",
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
