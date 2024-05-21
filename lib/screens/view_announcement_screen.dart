import 'package:flutter/material.dart';

class ViewAnnouncement extends StatefulWidget {
  final List<String> titles;
  final List<String> contents;
  int currentIndex;

  ViewAnnouncement({
    Key? key,
    required this.titles,
    required this.contents,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<ViewAnnouncement> createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<ViewAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Expanded(
          child: SizedBox(
            height: 50,
            child: Image.asset(
              'assets/images/app_bar_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(41),
                color: const Color(0xff002967),
              ),
              child: const Text(
                '게시물 보기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2.0,
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 2.0,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.titles[widget.currentIndex],
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 400,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 2.0,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.contents[widget.currentIndex],
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (widget.currentIndex > 0) {
                      setState(() {
                        // 이전 버튼이 클릭되면 currentIndex를 감소시킴
                        widget.currentIndex--;
                      });
                    }
                  },
                  child: const Text('이전 게시물'),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (widget.currentIndex < widget.titles.length - 1) {
                      setState(() {
                        // 다음 버튼이 클릭되면 currentIndex를 증가시킴
                        widget.currentIndex++;
                      });
                    }
                  },
                  child: const Text('다음 게시물'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
