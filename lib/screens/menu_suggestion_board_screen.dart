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
  List<dynamic> boardList = [];
  List<dynamic> topHotBoards = [];

  @override
  void initState() {
    super.initState();
    _futureBoardList = _apiService.fetchMenuBoardList(1, 1, "TIME");
    _futureHotBoardList = _apiService.fetchMenuBoardList(1, 1, "LIKE");
  }

  Widget _buildPost(int id, String title, String publisherName, int likeCount) {
    return GestureDetector(
      onTap: () async {
        final postDetail = await _apiService.fetchBoardDetail(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMenuSuggestionScreen(
              title: postDetail['title'],
              content: postDetail['content'],
            ),
          ),
        );
      },
      child: Container(
        height: 83,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xff002967),
          ),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Padding(
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
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    publisherName,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _incrementLikeCount,
                    icon: const Icon(Icons.thumb_up),
                  ),
                  Text('$likeCount'),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotPost(
      int id, String title, String publisherName, int likeCount) {
    return GestureDetector(
      onTap: () async {
        final postDetail = await _apiService.fetchBoardDetail(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMenuSuggestionScreen(
              title: postDetail['title'],
              content: postDetail['content'],
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 83,
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
                      'assets/images/hot_badge.png',
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
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            publisherName,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _incrementLikeCount,
                            icon: const Icon(Icons.thumb_up),
                          ),
                          Text('$likeCount'),
                          const SizedBox(width: 15),
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

  void _incrementLikeCount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('알림'),
        content: const Text('아직 개발 중인 기능입니다. 죄송합니다.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: Image.asset(
            'assets/images/app_bar_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                      padding: const EdgeInsets.all(8.0),
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
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(
                                  color: Colors.black,
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
                                  Text(
                                    'Hot 게시판',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: false,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: topHotBoards.length,
                                      itemBuilder: (context, index) {
                                        final board = topHotBoards[index];
                                        return _buildHotPost(
                                          board['id'],
                                          board['title'],
                                          board['publisherName'],
                                          board['likeCount'],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(
                                  color: Colors.black,
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
                                  Text(
                                    '일반 게시판',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: false,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: boardList.length,
                                      itemBuilder: (context, index) {
                                        final board = boardList[index];
                                        return _buildPost(
                                          board['id'],
                                          board['title'],
                                          board['publisherName'],
                                          board['likeCount'],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }
          }),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WriteMenuScreen(),
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    _futureBoardList =
                        _apiService.fetchMenuBoardList(1, 1, "TIME");
                    _futureHotBoardList =
                        _apiService.fetchMenuBoardList(1, 1, "LIKE");
                  });
                }
              });
            },
            icon: Image.asset(
              'assets/images/write_board_icon.png',
              width: 70,
              height: 70,
            ),
            label: const Text(''),
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
