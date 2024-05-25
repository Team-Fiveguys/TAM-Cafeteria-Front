import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/announcement_board_screen.dart';
import 'package:tam_cafeteria_front/screens/menu_suggestion_board_screen.dart';

//api연동은 다 되었습니다.
//enter_board 식당 아이디 별 들어가는 버튼 + ui 수정
//메뉴추천 게시물 리스트 보여주는 건 이대로 유지
// 메뉴추천 게시물 view에서 ui수정 , 좋아요 버튼 누르고 나갔다 들어와도 눌러진거 안눌러진거 유지, 자기 게시글  삭제
//공지게시판 리스트 ui 수정, admin만 수정 삭제 뜨게하기
class EnterBoardScreen extends StatelessWidget {
  const EnterBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
      crossAxisAlignment: CrossAxisAlignment.start, // Align buttons to the left
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0), // Add left padding
          child: Container(
            width: double.infinity, // Match parent width
            height: 60, // Set desired height

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
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MenuBoardScreen()),
                );
              },
              child: const Text('메뉴 건의 게시판'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0), // Add left padding
          child: Container(
            width: double.infinity, // Match parent width
            height: 60, // Set desired height

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
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnnounceBoardScreen()),
                );
              },
              child: const Text('공지게시판'),
            ),
          ),
        ),
      ],
    );
  }
}
