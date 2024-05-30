import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:intl/intl.dart';

class ViewAnnouncementScreen extends StatefulWidget {
  final int postId; // 게시물 ID를 받을 변수 추가
  final String title;
  final String content;
  final String publisherName;
  final String uploadTime;

  const ViewAnnouncementScreen({
    Key? key,
    required this.postId, // 생성자에 postId를 추가
    required this.title,
    required this.content,
    required this.publisherName,
    required this.uploadTime,
  }) : super(key: key);

  @override
  State<ViewAnnouncementScreen> createState() => _ViewAnnouncementScreenState();
}

class _ViewAnnouncementScreenState extends State<ViewAnnouncementScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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

  String formatDate(String uploadTime) {
    DateTime dateTime = DateTime.parse(uploadTime);

    String formattedDate = DateFormat('MM-dd HH:mm').format(dateTime.toLocal());

    return formattedDate;
  }

  void _updatePost() async {
    try {
      await ApiService.updatePost(
          widget.postId, _titleController.text, _contentController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물이 성공적으로 수정되었습니다.')),
      );

      // Set back to static text mode after updating
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물 수정 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: _isEditing
                        ? TextField(
                            controller: _titleController,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: '제목을 입력하세요',
                            ),
                          )
                        : Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: _isEditing
                          ? TextField(
                              controller: _contentController,
                              style: const TextStyle(fontSize: 18.0),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '내용을 입력하세요',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              maxLines: null,
                            )
                          : Text(
                              widget.content,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatDate(widget.uploadTime),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8), // 버튼의 패딩을 조정합니다.
                          minimumSize: const Size(5, 5), // 버튼의 최소 사이즈를 설정합니다.
                        ),
                        onPressed: _deletePost,
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColorDark,
                          size: 18,
                        ),
                        label: Text(
                          '삭제',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8), // 버튼의 패딩을 조정합니다.
                          minimumSize: const Size(5, 5), // 버튼의 최소 사이즈를 설정합니다.
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        icon: Icon(
                          Icons.change_circle,
                          color: Theme.of(context).primaryColorDark,
                          size: 18,
                        ),
                        label: Text(
                          _isEditing ? '취소' : '수정',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8), // 버튼의 패딩을 조정합니다.
                          minimumSize: const Size(5, 5), // 버튼의 최소 사이즈를 설정합니다.
                        ),
                        onPressed: _isEditing ? _updatePost : null,
                        icon: Icon(
                          Icons.save_alt_rounded,
                          color: Theme.of(context).primaryColorDark,
                          size: 18,
                        ),
                        label: Text(
                          '저장',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12,
                          ),
                        ),
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
