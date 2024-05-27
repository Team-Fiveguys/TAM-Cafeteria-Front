import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class ViewMenuSuggestionScreen extends StatefulWidget {
  final int postId; // 게시물 ID를 받을 변수 추가
  final String title;
  final String content;
  final String publisherName;
  final String uploadTime;
  final int likeCount;
  final String userId;
  final String publisherId;
  final bool isAdmin;

  const ViewMenuSuggestionScreen({
    Key? key,
    required this.postId, // 생성자에 postId를 추가
    required this.title,
    required this.content,
    required this.publisherName,
    required this.uploadTime,
    required this.likeCount,
    required this.userId,
    required this.publisherId,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<ViewMenuSuggestionScreen> createState() =>
      _ViewMenuSuggestionScreenState();
}

class _ViewMenuSuggestionScreenState extends State<ViewMenuSuggestionScreen> {
  bool isLiked = false;

  bool isAbleDelete = false;

  int likeCountValue = 0;
  @override
  void initState() {
    super.initState();
    likeCountValue = widget.likeCount;
    isAbleDelete = widget.isAdmin || widget.userId == widget.publisherId;
    print('isAbleDelete : $isAbleDelete');
    loadLike();
  }

  Future<void> loadLike() async {
    final instance = await ApiService.fetchBoardDetail(widget.postId);
    setState(() {
      likeCountValue = instance['likeCount'];
      isLiked = instance['toggleLike'];
    });
  }

  void toggleLike() async {
    try {
      await ApiService.togglePostLike(widget.postId);
      setState(() {
        isLiked = !isLiked;
        if (isLiked) {
          likeCountValue++;
        } else {
          likeCountValue--;
        }
      });
    } catch (e) {
      print('좋아요 상태 토글 중 오류 발생: $e');
    }
  }

  void reportPostConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("게시물 신고"),
          content: const Text("정말로 이 게시물을 신고하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                reportPost();
                Navigator.of(context).pop();
              },
              child: const Text("예"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("아니요"),
            ),
          ],
        );
      },
    );
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

    String formattedDate = DateFormat('MM-dd HH:mm').format(dateTime.toLocal());

    return formattedDate;
  }

  void delPost() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('알림'),
        content: const Text('이 게시물을 삭제하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            child: const Text('삭제'),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ApiService.deletePost(widget.postId);
                Navigator.of(context).pop();
              } on Exception catch (e) {
                // TODO
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
          ),
          TextButton(
            child: const Text('취소'),
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                  '메뉴 건의 게시글(식당이름)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
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
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 11,
                                  child: Image.asset(
                                    'assets/images/like_count.png',
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text('$likeCountValue | '),
                                Text(widget.publisherName),
                              ],
                            ),
                            Text(formatDate(widget.uploadTime)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8), // 버튼의 패딩을 조정합니다.
                      minimumSize: const Size(5, 5), // 버튼의 최소 사이즈를 설정합니다.
                    ),
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 18,
                    ),
                    label: Text(
                      "좋아요",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12,
                      ),
                    ),
                    onPressed: toggleLike,
                  ),
                  if (isAbleDelete)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8), // 버튼의 패딩을 조정합니다.
                        minimumSize: const Size(5, 5), // 버튼의 최소 사이즈를 설정합니다.
                      ),
                      onPressed: () {
                        delPost();
                      },
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
                          vertical: 4, horizontal: 8),
                      minimumSize: const Size(5, 5),
                    ),
                    onPressed: reportPostConfirmation,
                    icon: const Icon(
                      Icons.report_gmailerrorred_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                    label: Text(
                      '신고',
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
      ),
    );
  }
}
