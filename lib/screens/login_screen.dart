import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tam_cafeteria_front/screens/sign_up_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart'; // SignUpScreen 파일 import

//아직회원이 아니신가요? 회원가입> 안 붙음
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;

  Future<void> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        // print('카카오톡으로 로그인 성공 ${token.accessToken}, ${token.idToken}');
        ApiService.kakaoLoginPost(token.idToken!, token.accessToken);
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          ApiService.kakaoLoginPost(token.idToken!, token.accessToken);
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        ApiService.kakaoLoginPost(token.idToken!, token.accessToken);
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      // print('카카오톡으로 로그인 성공 ${token.accessToken}, ${token.idToken}');
      ApiService.kakaoLoginPost(token.idToken!, token.accessToken);
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Flexible(
            child: ListView(
              children: [
                Image.asset(
                  'assets/images/login_logo.png',
                  width: 167,
                  height: 81,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    width: 200,
                    height: 580, // 직사각형의 너비 조정
                    padding: const EdgeInsets.all(32.0), // 직사각형 내부의 패딩 추가
                    decoration: BoxDecoration(
                      color: const Color(0xff002967),
                      borderRadius: BorderRadius.circular(41), // 직사각형의 모서리를 둥글게
                      border: Border.all(
                        color: Colors.grey, // 테두리 색상 지정
                      ),
                    ),
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 55,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '아이디 입력',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // 모서리를 둥글게
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 55,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '비밀번호 입력',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // 모서리를 둥글게
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 10.0),
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
                              const Text(
                                '로그인 정보 유지',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 58)),
                            ),
                            onPressed: () {},
                            child: const Text(
                              '로그인',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Image.asset('assets/images/dot_line.png'),
                          Container(
                            alignment: Alignment.topRight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      '아이디 찾기',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Text(
                                    '|',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 5.0),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      '비밀번호 찾기',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Flexible(child: SizedBox(height: 40.0)),
                          const Center(
                            child: Text(
                              "sns 계정으로 로그인하기",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
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
                                      onPressed: () => kakaoLogin(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Flexible(
                            child: SizedBox(
                              height: 30,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  '아직 회원이 아니신가요?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                // ignore: prefer_const_constructors
                                child: Text(
                                  '회원가입>',
                                  style: const TextStyle(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
