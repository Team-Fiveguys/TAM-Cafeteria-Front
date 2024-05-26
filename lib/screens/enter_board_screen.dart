import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/announcement_board_screen.dart';
import 'package:tam_cafeteria_front/screens/menu_suggestion_board_screen.dart';

//api연동은 다 되었습니다.
//enter_board 식당 아이디 별 들어가는 버튼 + ui 수정
//메뉴추천 게시물 리스트 보여주는 건 이대로 유지
// 메뉴추천 게시물 view에서 ui수정 , 좋아요 버튼 누르고 나갔다 들어와도 눌러진거 안눌러진거 유지, 자기 게시글  삭제
//공지게시판 리스트 ui 수정, admin만 수정 삭제 뜨게하기

// 1. 스크롤 페이징(지금 1페이지가 넘어갔을 때 스크롤해서 페이징하는거 구현안되어있는거 같은데 맞나?)
// 2. 목록에서 각 게시글이 너무 큼
// 3. 게시글 단일 조회시 왜 상단에 메뉴 추천 게시물이야 추천-> 건의, 게시물-> 게시글 앗사리 저 윗 부분이 없어도 될듯?
// 4. 단일 게시글 ui 역시 뭔가 애매함(좋아요 갯수도 없고, 좋아요인지 하트인지 통일필요)
// 5. 신고하기 기능(신고 사유같은거 안받을거면 그래도 신고하시겠습니까 묻는 dialog 필요할듯)
// 6. 이름 표기를 관리자가 아닐때 최*원 으로 표기하기
// 7. 자세히 안봤지만 메뉴건의 내용 입력할때 글자수 세지나? 저번에 말했던거 안되어있음 하기
// 8. 공지 게시글 삭제하고 다시 되돌아갈때 새로고침 해주기 목록 반영이 안되어있음
// 9. 게시글 날짜하고 몇시몇분까지 표기하면 좋을듯?
// 10. 내가 좋아요 누른지 확인 안됨
// 11. 메뉴건의 게시물 삭제 추가(관리자도 삭제할수있게)
// 12. 게시판별 식당 Dropboxbutton 추가, 글쓰기 버튼 추가, 맨위로 가는 버튼 추가
// 13. 공지게시글은 왜 날짜 없어

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
