import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tam_cafeteria_front/screens/view_announcement_screen.dart';
import 'package:tam_cafeteria_front/screens/write_announce_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnounceBoardScreen extends StatefulWidget {
  const AnnounceBoardScreen({
    Key? key,
    required this.isAdmin,
    required this.scrollVisible,
  }) : super(key: key);
  final bool isAdmin;
  final ValueNotifier<bool> scrollVisible;
  @override
  State<AnnounceBoardScreen> createState() => _AnnounceBoardScreenState();
}

class _AnnounceBoardScreenState extends State<AnnounceBoardScreen> {
  late ScrollController _scrollController;
  late Future<List<Map<String, dynamic>>> _futureBoardList;
  late Future<List<Map<String, dynamic>>> _futureHotBoardList;
  final ApiService _apiService = ApiService();
  int _page = 1;
  int? cafeteriaId;
  String? selectedItem = '명진당';
  late String? cafeteriaName;

  @override
  void initState() {
    super.initState();
    cafeteriaId = 1;
    _scrollController = ScrollController();
    _futureBoardList = _apiService.fetchNoticeBoardList(1, _page);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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

  void saveMyCafeteria(String cafeteria) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('cafeteriaName', cafeteria);
  }

  void _loadBoardList(int cafeteriaId) {
    _futureBoardList = _apiService.fetchNoticeBoardList(
      cafeteriaId,
      1,
    );
  }

  Future<void> initializeAsyncTask() async {
    if (selectedItem != null) {
      cafeteriaName = selectedItem!;
    }
    final pref = await SharedPreferences.getInstance();

    setState(() {
      selectedItem = pref.getString('cafeteriaName') ?? '명진당';
      cafeteriaName = pref.getString('cafeteriaName') ?? '명진당';
      if (cafeteriaName == "명진당") {
        cafeteriaId = 1;
      }
      if (cafeteriaName == "학생회관") {
        cafeteriaId = 2;
      }
      if (cafeteriaName == "명돈이네") {
        cafeteriaId = 3;
      }
    });
  }

  String formatDate(String uploadTime) {
    DateTime dateTime = DateTime.parse(uploadTime);

    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());

    return formattedDate;
  }

  String maskPublisherName(String name, bool isAdmin) {
    if (isAdmin || name == "관리자") {
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

  Widget _buildPost(int id, String title, String content, String publisherName,
      String uploadTime) {
    publisherName = maskPublisherName(publisherName, widget.isAdmin);
    return GestureDetector(
      onTap: () async {
        final postDetail = await ApiService.fetchBoardDetail(id);
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
              cafeteriaId!,
              1,
            );
          });
        });
      },
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
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      '공지 게시판',
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
                      if (widget.isAdmin)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WriteAnnounceScreen(
                                    cafeteriaId: cafeteriaId),
                              ),
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  _futureBoardList =
                                      _apiService.fetchNoticeBoardList(
                                          cafeteriaId!, _page);
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
                        )
                      else
                        Container(),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerRight,
                        child: DropdownButton<String>(
                          value: selectedItem, // 현재 선택된 항목
                          icon: const Icon(
                              Icons.arrow_drop_down_sharp), // 아래 화살표 아이콘
                          iconSize: 24,
                          elevation: 20,
                          dropdownColor: Colors.white,
                          style:
                              const TextStyle(color: Colors.black), // 텍스트 스타일
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 10),
                const Divider(),
                boardList.isEmpty // 게시물이 없는 경우 Divider 숨김
                    ? Container() // 아무 내용이 없는 빈 컨테이너 반환
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                board['publisherName'] ?? "관리자",
                                board['uploadTime'],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                          ),
                          const Divider(),
                        ],
                      ),
              ],
            )
          ]);
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
