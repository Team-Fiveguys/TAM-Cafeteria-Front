import 'package:flutter/material.dart';

import 'package:tam_cafeteria_front/screens/login_screen.dart';
import 'package:tam_cafeteria_front/screens/menu_suggestion_board_screen.dart';

import 'package:flutter/rendering.dart';
import 'package:tam_cafeteria_front/screens/admin_screen.dart';
import 'package:tam_cafeteria_front/screens/main_screen.dart';
import 'package:tam_cafeteria_front/screens/my_page_screen.dart';

import 'package:tam_cafeteria_front/screens/notification_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final bool isAdmin = true;

  late int _selectedIndex; // 현재 선택된 탭의 인덱스

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _selectedIndex = isAdmin ? 2 : 0;
    _widgetOptions = <Widget>[
      MainScreen(),
      const Text(
        '검색',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      isAdmin ? const AdminPage() : const MyPage(),
    ];
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 사용자가 탭을 선택했을 때 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 탭의 인덱스를 업데이트
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF3e3e3e),
        primaryColorLight: const Color(0xFF97948f),
        primaryColorDark: const Color(0xFF515151),
        dividerColor: const Color(0xFFc6c6c6),
        cardColor: const Color(0xFFFFDA7B),
        canvasColor: const Color(0xFF002967),
      ),
      home: Scaffold(
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: _isVisible ? 60.0 : 0.0,
          child: Wrap(
            children: [
              BottomNavigationBar(
                backgroundColor: Colors.white,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '홈',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: '검색',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    label: isAdmin ? '관리자페이지' : '마이페이지',
                  ),
                ],
                currentIndex: _selectedIndex, // 현재 선택된 탭의 인덱스
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped, // 탭 선택 시 호출될 함수
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            leading: const Opacity(
              // 투명한 아이콘 버튼 추가
              opacity: 0.7,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: ApiService.test, // 아무것도 하지 않음
              ),
            ),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationCenter(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications),
                );
              }),
            ],
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
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
