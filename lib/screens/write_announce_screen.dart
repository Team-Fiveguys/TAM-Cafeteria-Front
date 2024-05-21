import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class WriteAnnounceScreen extends StatefulWidget {
  const WriteAnnounceScreen({Key? key}) : super(key: key);

  @override
  State<WriteAnnounceScreen> createState() => _WriteAnnounceScreenState();
}

class _WriteAnnounceScreenState extends State<WriteAnnounceScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 게시물 작성 함수
  void _postArticle() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    const String boardType = "NOTICE";
    const int cafeteriaId = 1;

    try {
      await ApiService.createPost(boardType, title, content, cafeteriaId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물이 성공적으로 작성되었습니다.')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물 작성에 실패했습니다: $e')),
      );

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              width: 900,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(41),
                color: const Color(0xff002967),
              ),
              child: const Text(
                '메뉴건의 글쓰기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: '원하는 메뉴를 작성해주세요',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: '글쓰기',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xff002967),
        height: 80,
        child: TextButton(
          onPressed: _postArticle,
          child: const Text(
            '게시하기',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
