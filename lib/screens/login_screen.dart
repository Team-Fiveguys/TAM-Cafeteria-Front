//네이버 로고 다시 다운로드
//상화좌우 간격 수정해야됨
//체크 색 정하고

import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/screens/sign_up_screen.dart'; // SignUpScreen 파일 import

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ListView(
          children: [
            Container(
              width: 420,
              height: 800, // 직사각형의 너비 조정
              padding: const EdgeInsets.all(16.0), // 직사각형 내부의 패딩 추가
              decoration: BoxDecoration(
                color: const Color(0xffffb800),
                borderRadius: BorderRadius.circular(41), // 직사각형의 모서리를 둥글게
                border: Border.all(
                  color: Colors.grey, // 테두리 색상 지정
                ),
              ),
              child: Stack(alignment: Alignment.topCenter, children: [
                Positioned(
                  top: 55,
                  child: SizedBox(
                    width: 200,
                    child: Image.asset('assets/images/app_bar_logo.png'),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 10,
                    ), // 아이디 입력창을 로고 위에 조금 올리기 위한 여백 추가
                    TextField(
                      decoration: InputDecoration(
                        hintText: '아이디 입력',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // 모서리를 둥글게
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '비밀번호 입력',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // 모서리를 둥글게
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        const Text('로그인 정보 유지'),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 58)),
                      ),
                      onPressed: () {},
                      child: const Text(
                        '로그인',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '아이디 찾기',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text('|'),
                        const SizedBox(width: 8.0),
                        TextButton(
                          onPressed: () {},
                          child: const Text('비밀번호 찾기',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Center(
                        child: Text(
                      "sns 계정으로 로그인하기",
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                            icon: Image.asset(
                                'assets/images/google_login_logo.png'),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                            icon: Image.asset(
                                'assets/images/naver_login_logo.png'),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: IconButton(
                            icon: Image.asset(
                                'assets/images/kakao_login_logo.png'),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '아직 회원이 아니신가요?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            '회원가입>',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration:
                                  TextDecoration.underline, // 텍스트에 밑줄 추가
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
