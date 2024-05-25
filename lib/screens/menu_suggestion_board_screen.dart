import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/view_menu_suggestion_screen.dart';
import 'package:tam_cafeteria_front/screens/write_menu_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class MenuBoardScreen extends StatefulWidget {
  const MenuBoardScreen({Key? key}) : super(key: key);

  @override
  State<MenuBoardScreen> createState() => _MenuBoardScreenState();
}

class _MenuBoardScreenState extends State<MenuBoardScreen> {
  late Future<List<Map<String, dynamic>>> _futureBoardList;
  late Future<List<Map<String, dynamic>>> _futureHotBoardList;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureBoardList = _apiService.fetchMenuBoardList(1, 1, "TIME");
    _futureHotBoardList = _apiService.fetchMenuBoardList(1, 1, "LIKE");
  }

  void reloadPage() {
    setState(() {
      _futureBoardList = _apiService.fetchMenuBoardList(1, 1, "TIME");
      _futureHotBoardList = _apiService.fetchMenuBoardList(1, 1, "LIKE");
    });
  }

  String formatDate(String uploadTime) {
    // DateTime 파싱
    DateTime dateTime = DateTime.parse(uploadTime);

    // 원하는 형식으로 포맷팅
    String formattedDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

    return formattedDate;
  }

  Widget _buildPost(int id, String title, String content, int likeCount,
      String publisherName, String uploadTime) {
    return GestureDetector(
      onTap: () async {
        final postDetail = await _apiService.fetchBoardDetail(id);
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
            ),
          ),
        ).then((value) {
          setState(() {
            _futureBoardList = _apiService.fetchMenuBoardList(1, 1, "TIME");
            _futureHotBoardList = _apiService.fetchMenuBoardList(1, 1, "LIKE");
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                        Text(publisherName),
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
        final postDetail = await _apiService.fetchBoardDetail(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMenuSuggestionScreen(
              title: postDetail['title'],
              content: postDetail['content'],
              publisherName: publisherName,
              uploadTime: uploadTime,
              postId: id,
            ),
          ),
        ).then((value) {
          setState(() {
            _futureBoardList = _apiService.fetchMenuBoardList(1, 1, "TIME");
            _futureHotBoardList = _apiService.fetchMenuBoardList(1, 1, "LIKE");
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
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
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

                  return Padding(
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
                        const SizedBox(height: 20),
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
                                  board['publisherName'],
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
                                  board['publisherName'],
                                  board['uploadTime'],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        });
    //   floatingActionButton: Builder(
    //     builder: (context) {
    //       return FloatingActionButton.extended(
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const WriteMenuScreen(),
    //             ),
    //           ).then((value) {
    //             if (value == true) {
    //               setState(() {
    //                 _futureBoardList =
    //                     _apiService.fetchMenuBoardList(1, 1, "TIME");
    //                 _futureHotBoardList =
    //                     _apiService.fetchMenuBoardList(1, 1, "LIKE");
    //               });
    //             }
    //           });
    //         },
    //         icon: Image.asset(
    //           'assets/images/write_board_icon.png',
    //           width: 70,
    //           height: 70,
    //         ),
    //         label: const Text(''),
    //         backgroundColor: Colors.black,
    //         shape: const CircleBorder(),
    //       );
    //     },
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    // );
  }
}
