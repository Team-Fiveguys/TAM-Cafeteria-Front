import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

// ignore: must_be_immutable
class WriteAnnounceScreen extends StatefulWidget {
  int? cafeteriaId;
  WriteAnnounceScreen({Key? key, this.cafeteriaId}) : super(key: key);

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
    final int cafeteriaId = widget.cafeteriaId!;

    try {
      await ApiService.createPost(boardType, title, content, cafeteriaId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글이 성공적으로 작성되었습니다.')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글 작성에 실패했습니다: $e')),
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
          title: Image.asset(
            'assets/images/app_bar_logo.png',
            fit: BoxFit.contain,
            height: 50, // SizedBox를 제거하고 직접 높이를 지정합니다.
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  '공지 글쓰기',
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
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          hintText: '공지를 작성해주세요',
                          border: OutlineInputBorder(
                            // 여기서 직접 정의
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none, // 테두리 없음 설정
                          ),
                          focusedBorder: OutlineInputBorder(
                            // 포커스 시 테두리를 무시하고 싶다면 이와 같이 설정
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
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
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          hintText: '글쓰기',
                          border: OutlineInputBorder(
                            // 여기서 직접 정의
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none, // 테두리 없음 설정
                          ),
                          focusedBorder: OutlineInputBorder(
                            // 포커스 시 테두리를 무시하고 싶다면 이와 같이 설정
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
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
