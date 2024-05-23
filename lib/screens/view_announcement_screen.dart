import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class ViewAnnouncementScreen extends StatefulWidget {
  final int postId;
  final String title;
  final String content;

  const ViewAnnouncementScreen({
    Key? key,
    required this.postId,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<ViewAnnouncementScreen> createState() => _ViewAnnouncementScreenState();
}

class _ViewAnnouncementScreenState extends State<ViewAnnouncementScreen> {
  void _deletePost() async {
    try {
      await ApiService.deletePost(widget.postId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물이 성공적으로 삭제되었습니다.')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물 삭제 중 오류가 발생했습니다: $e')),
      );
    }
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2.0,
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 2.0,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 2.0,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.content,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _deletePost,
                    child: const Text('삭제'),
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
