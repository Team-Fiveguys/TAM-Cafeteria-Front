import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//태그 달고
//폰트 줄이고 짜글이 좀 좌우 상하 길이 맞추고 좋아요 icon가져오고 숫자 늘어나게 만들고
//일반 게시물 만들고 이거 약간 일반 게시물 hot게시물 선정할수 있게
//글쓰기 아이콘 가져와서 넣고 글쓰기 페이지 만들기
class MenuBoardScreen extends StatefulWidget {
  const MenuBoardScreen({super.key});

  @override
  State<MenuBoardScreen> createState() => _MenuBoardScreenState();
}

class _MenuBoardScreenState extends State<MenuBoardScreen> {
  int _likeCount = 0; // 처음에는 30으로 시작

  void _incrementLikeCount() {
    setState(() {
      _likeCount++; // 숫자를 1씩 증가
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // FloatingActionButton을 누를 때 수행할 작업
        },
        icon: Image.asset(
          'assets/images/write_board_icon.png',
          width: 100, // 이미지의 너비 조절
          height: 100, // 이미지의 높이 조절
        ),
        label: const Text(''), // 라벨은 비워둠
        backgroundColor: Colors.black, // 배경색을 투명으로 설정하여 이미지만 보이도록 함
        shape: const CircleBorder(), // 원형으로 설정
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                '메뉴건의 게시판',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
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
                children: [
                  Positioned(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'HOT 게시판',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(
                              0xff002967,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(
                            19,
                          ),
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
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 11, 0, 10),
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '짜글이',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          '짜글이...',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // IconButton을 누르면 _incrementLikeCount 함수를 호출
                                          _incrementLikeCount();
                                        },
                                        icon: const Icon(Icons.thumb_up),
                                      ),
                                      Text('$_likeCount'),
                                      const SizedBox(
                                        width: 15,
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
                  const SizedBox(height: 10.0),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(
                          0xff002967,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        19,
                      ),
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
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 11, 0, 10),
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '짜글이',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '짜글이...',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // IconButton을 누르면 _incrementLikeCount 함수를 호출
                                      _incrementLikeCount();
                                    },
                                    icon: const Icon(Icons.thumb_up),
                                  ),
                                  Text('$_likeCount'),
                                  const SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(
                          0xff002967,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        19,
                      ),
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
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 11, 0, 10),
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '짜글이',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '짜글이...',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // IconButton을 누르면 _incrementLikeCount 함수를 호출
                                      _incrementLikeCount();
                                    },
                                    icon: const Icon(Icons.thumb_up),
                                  ),
                                  Text('$_likeCount'),
                                  const SizedBox(
                                    width: 15,
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
            ),
            const SizedBox(height: 20.0),
            const Text(
              '일반 게시물',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(
                      0xff002967,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(
                    19,
                  ),
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 11, 0, 10),
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '짜글이',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '짜글이...',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // IconButton을 누르면 _incrementLikeCount 함수를 호출
                                  _incrementLikeCount();
                                },
                                icon: const Icon(Icons.thumb_up),
                              ),
                              Text('$_likeCount'),
                              const SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
