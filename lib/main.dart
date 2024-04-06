import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/main_screen.dart';

void main() {
  runApp(const TamCafeteria());
}

class TamCafeteria extends StatelessWidget {
  const TamCafeteria({super.key});

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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
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
        body: MainScreen(),
      ),
    );
  }
}
