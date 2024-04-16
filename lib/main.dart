import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/login_screen.dart';
import 'package:tam_cafeteria_front/screens/menu_suggestion_board_screen.dart';
import 'package:tam_cafeteria_front/screens/notification_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color(0xFF3e3e3e),
          primaryColorLight: const Color(0xFF97948f),
          primaryColorDark: const Color(0xFF515151),
          dividerColor: const Color(0xFFc6c6c6)),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            leading: Opacity(
              // 투명한 아이콘 버튼 추가
              opacity: 0.7,
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {}, // 아무것도 하지 않음
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset(
                        'assets/images/app_bar_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const MenuBoardScreen(),
      ),
    );
  }
}
