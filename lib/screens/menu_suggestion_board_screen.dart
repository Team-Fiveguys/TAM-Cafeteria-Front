import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/screens/view_menu_suggestion_screen.dart';
import 'package:tam_cafeteria_front/screens/write_menu_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuBoardScreen extends StatefulWidget {
  const MenuBoardScreen({
    Key? key,
    required this.userId,
    required this.isAdmin,
  }) : super(key: key);
  final String userId;
  final bool isAdmin;
  @override
  State<MenuBoardScreen> createState() => _MenuBoardScreenState();
}

class _MenuBoardScreenState extends State<MenuBoardScreen> {
  late Future<List<Map<String, dynamic>>> _futureBoardList;
  late Future<List<Map<String, dynamic>>> _futureHotBoardList;
  final ApiService _apiService = ApiService();
  int _boardPageNumber = 1;
  int? cafeteriaId;
  String? selectedItem = '명진당';
  late String? cafeteriaBoardName;
  final bool _showBackToTopButton = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);

    // 초기화
    _futureBoardList = Future.value([]);
    _futureHotBoardList = Future.value([]);

    initializeAsyncTask(); // 저장된 식당 정보를 로드하여 초기화
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    setState(() {
      _boardPageNumber++;
      _loadBoardList(cafeteriaId!);
    });
  }

  void _loadBoardList(int cafeteriaId) {
    setState(() {
      _futureBoardList =
          _apiService.fetchMenuBoardList(cafeteriaId, _boardPageNumber, "TIME");
      _futureHotBoardList =
          _apiService.fetchMenuBoardList(cafeteriaId, 1, "LIKE");
    });
  }

  // 사용자가 선택한 식당 정보를 저장합니다.
  void saveMyCafeteria(String cafeteriaBoardName) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('cafeteriaBoardName', cafeteriaBoardName);
  }

  void reloadPage() {
    setState(() {
      _futureBoardList = _apiService.fetchMenuBoardList(1, 1, "TIME");
      _futureHotBoardList = _apiService.fetchMenuBoardList(1, 1, "LIKE");
    });
  }

  String formatDate(String uploadTime) {
    DateTime dateTime = DateTime.parse(uploadTime);
    String formattedDate = DateFormat('MM-dd HH:mm').format(dateTime.toLocal());
    return formattedDate;
  }

  String maskPublisherName(String name, bool isAdmin) {
    if (isAdmin || name == "익명") {
      return name;
    } else {
      if (name.length == 2) {
        return '${name[0]}*';
      } else if (name.length > 2) {
        return name[0] + '*' * (name.length - 2) + name[name.length - 1];
      } else {
        return name; // 이름이 한 글자일 경우 그대로 반환
      }
    }
  }

  Future<void> initializeAsyncTask() async {
    final pref = await SharedPreferences.getInstance();
    selectedItem = pref.getString('cafeteriaBoardName') ?? '명진당';
    cafeteriaBoardName = selectedItem;

    if (cafeteriaBoardName == "명진당") {
      cafeteriaId = 1;
    } else if (cafeteriaBoardName == "학생회관") {
      cafeteriaId = 2;
    } else if (cafeteriaBoardName == "명돈이네") {
      cafeteriaId = 3;
    }

    setState(() {
      _futureBoardList = _apiService.fetchMenuBoardList(
          cafeteriaId!, _boardPageNumber, "TIME");
      _futureHotBoardList =
          _apiService.fetchMenuBoardList(cafeteriaId!, 1, "LIKE");
    });
  }

  Widget _buildPost(int id, String title, String content, int likeCount,
      String publisherName, String uploadTime) {
    publisherName = maskPublisherName(publisherName, widget.isAdmin);
    return GestureDetector(
      onTap: () async {
        final postDetail = await ApiService.fetchBoardDetail(id);
        // 'ViewMenuSuggestionScreen'으로 이동합니다. 이 때, 몇 가지 매개변수를 전달합니다.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMenuSuggestionScreen(
              title: postDetail['title'],
              content: postDetail['content'],
              publisherName: publisherName,
              uploadTime: uploadTime,
              postId: id,
              likeCount: likeCount,
              userId: widget.userId,
              publisherId: postDetail['userId'].toString(),
              isAdmin: widget.isAdmin,
            ),
          ),
        ).then((value) {
          setState(() {
            _futureBoardList =
                _apiService.fetchMenuBoardList(cafeteriaId!, 1, "TIME");
            _futureHotBoardList =
                _apiService.fetchMenuBoardList(cafeteriaId!, 1, "LIKE");
          });
        });
      },
      child: Container(
        height: 99,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xff002967),
          ),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 11, 0, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          // 'isAdmin'이 true일 경우 id 부분을 작은 글씨로 표시
                          if (widget.isAdmin)
                            TextSpan(
                              text: '($id) ',
                              style: const TextStyle(
                                fontSize: 14.0, // id 부분의 글자 크기를 작게 설정
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          // 제목(title) 부분
                          TextSpan(
                            text: title,
                            style: const TextStyle(
                              fontSize: 18.0, // 제목 부분의 기본 글자 크기
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow
                          .ellipsis, // 이 부분은 RichText에 직접 적용되지 않습니다.
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/like_count.png',
                          width: 11,
                        ),
                        const SizedBox(width: 3),
                        Text('$likeCount'),
                        const SizedBox(width: 8), //
                        Text(formatDate(uploadTime)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            publisherName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotPost(int id, String title, String content, int likeCount,
      String publisherName, String uploadTime) {
    bool isLiked = false; // 현재 좋아요 상태를 추적합니다.
    publisherName = maskPublisherName(publisherName, widget.isAdmin);
    void toggleLike() async {
      try {
        // 좋아요 상태를 전환합니다.
        await ApiService.togglePostLike(id);
        setState(() {
          isLiked = !isLiked; // 좋아요 상태를 업데이트합니다.
        });
      } catch (e) {
        print('좋아요 상태 전환 중 오류 발생: $e');
      }
    }

    return GestureDetector(
      onTap: () async {
        final postDetail = await ApiService.fetchBoardDetail(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMenuSuggestionScreen(
              title: postDetail['title'],
              content: postDetail['content'],
              publisherName: publisherName,
              uploadTime: uploadTime,
              postId: id,
              likeCount: likeCount,
              userId: widget.userId,
              publisherId: postDetail['userId'].toString(),
              isAdmin: widget.isAdmin,
            ),
          ),
        ).then((value) {
          setState(() {
            _futureBoardList =
                _apiService.fetchMenuBoardList(cafeteriaId!, 1, "TIME");
            _futureHotBoardList =
                _apiService.fetchMenuBoardList(cafeteriaId!, 1, "LIKE");
          });
        });
      },
      child: Stack(
        children: [
          Container(
            height: 99,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xff002967),
              ),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/select_badge.png',
                      scale: 2.55,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 11, 0, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    // 'isAdmin'이 true일 경우 id 부분을 작은 글씨로 표시
                                    if (widget.isAdmin)
                                      TextSpan(
                                        text: '($id) ',
                                        style: const TextStyle(
                                          fontSize: 14.0, // id 부분의 글자 크기를 작게 설정
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    // 제목(title) 부분
                                    TextSpan(
                                      text: title,
                                      style: const TextStyle(
                                        fontSize: 18.0, // 제목 부분의 기본 글자 크기
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // 이 부분은 RichText에 직접 적용되지 않습니다.
                                maxLines: 1,
                              )),
                          const SizedBox(height: 4.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Text(
                              content,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
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
                              Text('$likeCount'),
                              const SizedBox(width: 8),
                              Text(formatDate(uploadTime)),
                              const SizedBox(width: 8),
                              Text(publisherName),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: Image.asset(
                              'assets/images/hot_badge.png',
                              scale: 2.55,
                            ),
                          ),
                          const SizedBox(
                            width: 13,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureBoardList,
        builder: (context, boardSnapshot) {
          if (boardSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (boardSnapshot.hasError) {
            return Center(child: Text('Error: ${boardSnapshot.error}'));
          } else {
            final boardList = boardSnapshot.data!;
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureHotBoardList,
              builder: (context, hotBoardSnapshot) {
                if (hotBoardSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (hotBoardSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${hotBoardSnapshot.error}'));
                } else {
                  final hotBoardList = hotBoardSnapshot.data!;
                  final topHotBoards = hotBoardList.take(3).toList();

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.maxScrollExtent ==
                          scrollInfo.metrics.pixels) {
                        // 스크롤이 끝까지 내려갔을 때
                        _boardPageNumber++; // 페이지 번호 증가
                        _loadBoardList(
                          cafeteriaId!,
                        );
                      }
                      return true;
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(41),
                                color: const Color(0xff002967),
                              ),
                              child: const Text(
                                '메뉴건의 게시판',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WriteMenuScreen(
                                            cafeteriaId: cafeteriaId),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _futureBoardList =
                                              _apiService.fetchMenuBoardList(
                                                  cafeteriaId!, 1, "TIME");
                                          _futureHotBoardList =
                                              _apiService.fetchMenuBoardList(
                                                  cafeteriaId!, 1, "LIKE");
                                        });
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit_square,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  label: Text(
                                    '글쓰기',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                                Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: DropdownButton<String>(
                                      value: selectedItem, // 현재 선택된 항목
                                      icon: const Icon(Icons
                                          .arrow_drop_down_sharp), // 아래 화살표 아이콘
                                      iconSize: 24,
                                      elevation: 20,
                                      dropdownColor: Colors.white,
                                      style: const TextStyle(
                                          color: Colors.black), // 텍스트 스타일
                                      underline: Container(
                                        height: 2,
                                        color: Colors.black,
                                      ), // 현재 선택된 항목
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedItem = newValue;
                                          // 선택된 항목에 따라 cafeteriaId 설정
                                          if (newValue == "명진당") {
                                            cafeteriaId = 1;
                                          } else if (newValue == "학생회관") {
                                            cafeteriaId = 2;
                                          } else {
                                            cafeteriaId = 3;
                                          }
                                          // cafeteriaId와 함께 게시글 목록 다시 불러오기
                                          _loadBoardList(cafeteriaId!);
                                        });
                                      },
                                      items: <String>[
                                        '명진당',
                                        '학생회관',
                                        '명돈이네',
                                      ] // 선택 가능한 항목 리스트
                                          .map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                    )),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: topHotBoards.length,
                                  itemBuilder: (context, index) {
                                    final board = topHotBoards[index];
                                    return _buildHotPost(
                                      board['id'],
                                      board['title'],
                                      board['content'],
                                      board['likeCount'],
                                      board['publisherName'] ?? "익명",
                                      board['uploadTime'],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: boardList.length,
                                  itemBuilder: (context, index) {
                                    final board = boardList[index];
                                    return _buildPost(
                                      board['id'],
                                      board['title'],
                                      board['content'],
                                      board['likeCount'],
                                      board['publisherName'] ?? "익명",
                                      board['uploadTime'],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                }
              },
            );
          }
        });
  }
}
