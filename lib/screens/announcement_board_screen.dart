import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/view_announcement_screen.dart';
import 'package:tam_cafeteria_front/screens/write_announce_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

class AnnounceBoardScreen extends StatefulWidget {
  const AnnounceBoardScreen({Key? key}) : super(key: key);

  @override
  State<AnnounceBoardScreen> createState() => _AnnounceBoardScreenState();
}

class _AnnounceBoardScreenState extends State<AnnounceBoardScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _futureAnnounceList;

  @override
  void initState() {
    super.initState();
    _futureAnnounceList = _apiService.fetchNoticeBoardList(1, 1, "TIME");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/app_bar_logo.png',
          fit: BoxFit.contain,
          height: 50, // SizedBox를 제거하고 직접 높이를 지정합니다.
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureAnnounceList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final announceList = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(41),
                      color: const Color(0xff002967),
                    ),
                    child: const Text(
                      '공지 게시판',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  for (int i = 0; i < announceList.length; i++) ...[
                    buildAnnouncementItem(
                      context,
                      index: i,
                      title: announceList[i]['title'],
                      publisherName: announceList[i]['publisherName'],
                      boardId: announceList[i]['id'],
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WriteAnnounceScreen(),
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    _futureAnnounceList =
                        _apiService.fetchNoticeBoardList(1, 1, "TIME");
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

  Widget buildAnnouncementItem(BuildContext context,
      {required int index,
      required String title,
      required String publisherName,
      required int boardId}) {
    return GestureDetector(
      onTap: () async {
        final postDetail = await _apiService.fetchBoardDetail(boardId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewAnnouncementScreen(
              title: postDetail['title'],
              content: postDetail['content'],
              postId: boardId,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xff002967),
          ),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 11, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      ' $publisherName',
                      style: const TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 11, 20, 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
