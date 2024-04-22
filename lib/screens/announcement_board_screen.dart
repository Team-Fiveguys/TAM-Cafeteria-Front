import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/view_announcement_screen.dart';

class AnnounceBoardScreen extends StatefulWidget {
  const AnnounceBoardScreen({Key? key}) : super(key: key);

  @override
  State<AnnounceBoardScreen> createState() => _AnnounceBoardScreenState();
}

class _AnnounceBoardScreenState extends State<AnnounceBoardScreen> {
  final List<int> _likeCounts = [0, 0, 0, 0, 0]; // 각 공지사항의 좋아요 수를 유지하는 리스트

  void _incrementLikeCount(int index) {
    setState(() {
      // 선택된 공지사항의 좋아요 수를 증가
      _likeCounts[index]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              // Expanded로 Row의 자식을 감싸서 중앙 정렬 유지
              child: SizedBox(
                height: 50,
                child: Image.asset(
                  'assets/images/app_bar_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
            // 각 공지 항목에 대한 위젯을 생성하여 반환하는 함수를 호출
            buildAnnouncementItem(
              context,
              index: 0,
              title: '4월 1주차 식단 채택 목록',
              content: '짜장면',
            ),
            const SizedBox(height: 20.0),
            buildAnnouncementItem(
              context,
              index: 1,
              title:
                  '3월 4주차 식단 채택 목록1111111111111111111111111111111111111111111111111111111111111111111111111',
              content: '짬뽕짬뽕ㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂ',
            ),
            const SizedBox(height: 20.0),
            buildAnnouncementItem(
              context,
              index: 2,
              title: '3월 3주차 식단 채택 목록',
              content: '스시시ㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣ',
            ),
            const SizedBox(height: 20.0),
            buildAnnouncementItem(
              context,
              index: 3,
              title: '3월 2주차 식단 채택 목록',
              content:
                  '물고기, 스테이크, 샐러드, 파스타, 피자, 치킨, 샌드위치, 스시, 스프, 햄버거, 타코, 새우, 소시지, 카레, 떡볶이, 감자튀김, 고기구이, 삼겹살, 닭가슴살, 라면, 김밥, 새우튀김, 치즈, 오믈렛, 라자냐, 쿠키, 아이스크림, ',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnnouncementItem(BuildContext context,
      {required int index, required String title, required String content}) {
    return GestureDetector(
      onTap: () {
        // 공지 상세 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewAnnouncement(
              titles: const [
                '4월 1주차 식단 채택 목록',
                '3월 4주차 식단 채택 목록1111111111111111111111111111111111111111111111111111111111111111111111111',
                '3월 3주차 식단 채택 목록',
                '3월 2주차 식단 채택 목록'
              ], // 제목 목록 전달
              contents: const [
                '짜장면',
                '짬뽕짬뽕ㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂㅂ',
                '스시시ㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣㅣ',
                '물고기, 스테이크, 샐러드, 파스타, 피자, 치킨, 샌드위치, 스시, 스프, 햄버거, 타코, 새우, 소시지, 카레, 떡볶이, 감자튀김, 고기구이, 삼겹살, 닭가슴살, 라면, 김밥, 새우튀김, 치즈, 오믈렛, 라자냐, 쿠키, 아이스크림, '
              ], // 내용 목록 전달
              currentIndex: index, // 현재 인덱스 전달
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
                      content,
                      style: const TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    // 좋아요 수 증가
                    _incrementLikeCount(index);
                  },
                  icon: const Icon(Icons.thumb_up),
                ),
                Text('${_likeCounts[index]}'), // 해당 공지사항의 좋아요 수 표시
                const SizedBox(width: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
