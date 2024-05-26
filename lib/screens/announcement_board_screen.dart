import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/view_announcement_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class AnnounceBoardScreen extends StatefulWidget {
  const AnnounceBoardScreen({Key? key}) : super(key: key);

  @override
  State<AnnounceBoardScreen> createState() => _AnnounceBoardScreenState();
}

class _AnnounceBoardScreenState extends State<AnnounceBoardScreen> {
  late ScrollController _scrollController;
  late Future<List<Map<String, dynamic>>> _futureBoardList;
  late Future<List<Map<String, dynamic>>> _futureHotBoardList;
  final ApiService _apiService = ApiService();
  int _page = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _futureBoardList = _apiService.fetchNoticeBoardList(1, _page);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // If scrolled to the bottom, load the next page
      _page++;
      _fetchNextPage();
    }
  }

  void _fetchNextPage() async {
    final List<Map<String, dynamic>> nextPage =
        await _apiService.fetchNoticeBoardList(1, _page);
    setState(() {
      _futureBoardList =
          _futureBoardList.then((existingList) => existingList + nextPage);
    });
  }

  void reloadPage() {
    setState(() {
      _futureBoardList = _apiService.fetchNoticeBoardList(
        1,
        1,
      );
    });
  }

  String formatDate(String uploadTime) {
    // DateTime 파싱
    DateTime dateTime = DateTime.parse(uploadTime);

    // 원하는 형식으로 포맷팅
    String formattedDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

    return formattedDate;
  }

  Widget _buildPost(int id, String title, String content, String publisherName,
      String uploadTime) {
    return GestureDetector(
      onTap: () async {
        final postDetail = await _apiService.fetchBoardDetail(id);
        // 'ViewMenuSuggestionScreen'으로 이동합니다. 이 때, 몇 가지 매개변수를 전달합니다.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewAnnouncementScreen(
              title: postDetail['title'],
              content: postDetail['content'],
              publisherName: publisherName,
              uploadTime: uploadTime,
              postId: id,
            ),
          ),
        ).then((value) {
          setState(() {
            _futureBoardList = _apiService.fetchNoticeBoardList(
              1,
              1,
            );
            _futureHotBoardList = _apiService.fetchNoticeBoardList(
              1,
              1,
            );
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
          return ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: boardList.length,
            itemBuilder: (context, index) {
              final board = boardList[index];
              return _buildPost(
                board['id'],
                board['title'],
                board['content'],
                board['publisherName'],
                board['uploadTime'],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        }
      },
    );
  }

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
