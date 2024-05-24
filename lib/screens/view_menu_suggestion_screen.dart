import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class ViewMenuSuggestionScreen extends StatefulWidget {
  final int postId; // 게시물 ID를 받을 변수 추가
  final String title;
  final String content;
  final String publisherName;
  final String uploadTime;

  const ViewMenuSuggestionScreen({
    Key? key,
    required this.postId, // 생성자에 postId를 추가
    required this.title,
    required this.content,
    required this.publisherName,
    required this.uploadTime,
  }) : super(key: key);

  @override
  State<ViewMenuSuggestionScreen> createState() =>
      _ViewMenuSuggestionScreenState();
}

class _ViewMenuSuggestionScreenState extends State<ViewMenuSuggestionScreen> {
  bool isLiked = false;

  void toggleLike() async {
    try {
      await ApiService.togglePostLike(widget.postId);
      setState(() {
        isLiked = !isLiked;
      });
    } catch (e) {
      print('좋아요 상태 토글 중 오류 발생: $e');
    }
  }

  void reportPost() async {
    try {
      await ApiService.reportPost(widget.postId);
      print('게시물을 성공적으로 신고했습니다.');
    } catch (e) {
      print('게시물 신고 중 오류 발생: $e');
    }
  }

  String formatDate(String uploadTime) {
    DateTime dateTime = DateTime.parse(uploadTime);

    String formattedDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/app_bar_logo.png',
          fit: BoxFit.contain,
          height: 50,
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
                '메뉴 추천 게시물',
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
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        onPressed: toggleLike,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
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
                                  color: Colors.grey,
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.content,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(widget.publisherName),
                          const Text('|'),
                          Text(formatDate(widget.uploadTime)),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: reportPost,
                            child: const Text('신고하기'),
                          ),
                        ],
                      ),
                    ],
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
