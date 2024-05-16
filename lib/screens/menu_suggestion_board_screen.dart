import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tam_cafeteria_front/screens/announcement_board_screen.dart';

//태그 달고
//폰트 줄이고 메뉴A 좀 좌우 상하 길이 맞추고 좋아요 icon가져오고 숫자 늘어나게 만들고
//일반 게시물 만들고 이거 약간 일반 게시물 hot게시물 선정할수 있게
//글쓰기 아이콘 가져와서 넣고 글쓰기 페이지 만들기
class MenuBoardScreen extends StatefulWidget {
  const MenuBoardScreen({super.key});

  @override
  State<MenuBoardScreen> createState() => _MenuBoardScreenState();
}

class _MenuBoardScreenState extends State<MenuBoardScreen> {
  // final int _likeCount = 0; // 처음에는 30으로 시작

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
    // setState(() {
    //   _likeCount++; // 숫자를 1씩 증가
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AnnounceBoardScreen()),
            );
          },
          child: Container(
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
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'HOT 게시판',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    height: 83,
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
                              padding: EdgeInsets.fromLTRB(20, 11, 0, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '순대국밥',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '너무 먹고싶어요',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
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
                                  const Text('153'),
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
                height: 83,
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
                          padding: EdgeInsets.fromLTRB(20, 11, 0, 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '삼겹살구이',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '고기가 최고야',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
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
                              const Text('144'),
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
                height: 83,
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
                          padding: EdgeInsets.fromLTRB(20, 11, 0, 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '김치찌개',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '돼지고기 김치찌개!',
                                style: TextStyle(fontSize: 14.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
                              const Text('99'),
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
            height: 83,
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
                      padding: EdgeInsets.fromLTRB(20, 11, 0, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '김치피자탕수육',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '김피탕 먹고싶어요',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
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
                          const Text('1'),
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
    );
  }
}
