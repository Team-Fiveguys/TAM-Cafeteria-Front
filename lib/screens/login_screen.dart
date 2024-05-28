import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
// import 'package:path/path.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:tam_cafeteria_front/main.dart';
import 'package:tam_cafeteria_front/provider/access_token_provider.dart';
import 'package:tam_cafeteria_front/provider/login_state_provider.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';
import 'package:tam_cafeteria_front/screens/sign_up_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

//아직회원이 아니신가요? 회원가입> 안 붙음
class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  // final bool _isChecked = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginWithKakao(BuildContext context, WidgetRef ref) async {
    final tokenProvider = ref.read(accessTokenProvider.notifier);
    final loginProvier = ref.read(loginStateProvider.notifier);
    bool isClosed = false;
    showDialog(
      context: context,
      barrierDismissible:
          false, // 사용자가 다이얼로그 바깥을 터치하거나 뒤로가기를 눌러 다이얼로그를 닫지 못하게 함
      builder: (builderContext) => PopScope(
        canPop: true, // Android 뒤로가기 버튼으로도 닫지 못하게 함
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isClosed = true;
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            const Center(
              child: CircularProgressIndicator(), // 로딩 인디케이터
            ),
          ],
        ),
      ),
    );
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        // print('카카오톡으로 로그인 성공 ${token.accessToken}, ${token.idToken}');
        final accessToken =
            await ApiService.postKakaoLogin(token.idToken!, token.accessToken);
        print('카카오톡으로 로그인 성공');
        if (accessToken != null) {
          tokenProvider.setToken(accessToken);
          loginProvier.login();
          Navigator.pop(context, "login success");
          if (!isClosed) {
            Navigator.pop(context, "login success");
          }
          //  ref.read(loginStateProvider.state).state = true;
        }

        // message == "true" ? Navigator.of(context).pop(true) : print(message);
      } on Exception catch (e) {
        if (e is PlatformException && e.code == 'CANCELED') {
          return;
        }
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('에러'),
            content: Text(e.toString()),
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
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("카카오톡 설치"),
            content: const Text("카카오톡이 설치되어 있지 않습니다. 카카오톡 설치 후 다시 이용해주세요"),
            actions: <Widget>[
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> loginWithApple(BuildContext context, WidgetRef ref) async {
    bool isClosed = false;
    if (Platform.isAndroid) {
      // TODO: 나중에 redirect로 바꾸기
      // 안드로이드 기기에서 실행되었다면 경고 다이얼로그 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('경고'),
          content: const Text('애플 로그인은 iOS 기기에서만 지원됩니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () => Navigator.of(context).pop(), // 다이얼로그 닫기
            ),
          ],
        ),
      );
      return; // 함수 종료
    }

    final tokenProvider = ref.read(accessTokenProvider.notifier);
    final loginProvier = ref.read(loginStateProvider.notifier);

    showDialog(
      context: context,
      barrierDismissible:
          false, // 사용자가 다이얼로그 바깥을 터치하거나 뒤로가기를 눌러 다이얼로그를 닫지 못하게 함
      builder: (builderContext) => PopScope(
        canPop: true, // Android 뒤로가기 버튼으로도 닫지 못하게 함
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isClosed = true;
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            const Center(
              child: CircularProgressIndicator(), // 로딩 인디케이터
            ),
          ],
        ),
      ),
    );
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print("loginWithApple : $credential");

      final accessToken = await ApiService.postAppleLogin(
          credential.userIdentifier,
          credential.identityToken,
          credential.authorizationCode);
      print('애플로 로그인 성공');
      if (accessToken != null) {
        tokenProvider.setToken(accessToken);
        loginProvier.login();
        //  ref.read(loginStateProvider.state).state = true;
      } else {
        throw Exception("로그인 실패");
      }
      Navigator.pop(context, "login success");
      if (!isClosed) {
        Navigator.pop(context, "login success");
      }
    } on Exception catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('에러'),
          content: Text('애플 로그인 실패 $error'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      //Navigator.pop(context, "login"); // 로그인 시도가 끝나면 로딩 다이얼로그 닫기
    }
  }

  void loginWithEmail(BuildContext context, WidgetRef ref) async {
    final tokenProvider = ref.read(accessTokenProvider.notifier);
    final loginProvier = ref.read(loginStateProvider.notifier);
    bool success = false;
    String msg = "";
    String? accessToken;

    // 이메일과 비밀번호를 가져옴
    String email = _idController.text;
    String password = _passwordController.text;

    // 이메일과 비밀번호가 빈 문자열인지 확인
    if (email.isEmpty) {
      msg = "이메일을 입력하세요";
    } else if (password.isEmpty) {
      msg = "비밀번호를 입력하세요";
    } else {
      try {
        accessToken = await ApiService.postSignIn(
            _idController.text, _passwordController.text);
        success = accessToken != null ? true : false;
        if (await TokenManagerWithSP.loadToken() != null) {
          tokenProvider.clearToken();
        }
        if (accessToken != null) {
          tokenProvider.setToken(accessToken);
          loginProvier.login();
          //  ref.read(loginStateProvider.state).state = true;
        }
      } on Exception catch (e) {
        msg = e.toString();
      }
    }

    // 결과 메시지 출력
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
        );
      },
    );

    // 로그인 성공 시 화면 닫기
    if (success) {
      Navigator.pop(context);
      Navigator.pop(context, "login success");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
        ),
      ),
      //여기 수직 center 가능?
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Image.asset(
                'assets/images/login_logo.png',
                width: 167,
                height: 81,
              ),
              const SizedBox(
                height: 10,
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
                            controller: _idController,
                            decoration: InputDecoration(
                              hintText: '이메일 입력',
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
                            controller: _passwordController,
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
                        // 일단 로그인 유지로 하기, 나중에 상태 변수 관리하다 앱 종료할때 지우면 될듯
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       value: _isChecked,
                        //       onChanged: (value) {}, // TODO : 로그인 유지 관리하기
                        //     ),
                        //     const Text(
                        //       '로그인 정보 유지',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 13,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 58)),
                          ),
                          onPressed: () => loginWithEmail(context, ref),
                          child: const Text(
                            '로그인',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Image.asset('assets/images/dot_line.png'),
                        // Flexible(
                        //   fit: FlexFit.tight,
                        //   child: Container(
                        //     alignment: Alignment.topRight,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         TextButton(
                        //           onPressed: () {
                        //             showDialog(
                        //               context: context,
                        //               builder: (ctx) => AlertDialog(
                        //                 title: const Text('알림'),
                        //                 content: const Text(
                        //                     '아직 개발 중인 기능입니다. 죄송합니다.'),
                        //                 actions: <Widget>[
                        //                   TextButton(
                        //                     child: const Text('확인'),
                        //                     onPressed: () {
                        //                       Navigator.of(ctx).pop();
                        //                     },
                        //                   ),
                        //                 ],
                        //               ),
                        //             );
                        //           },
                        //           child: const Text(
                        //             '아이디 찾기',
                        //             style: TextStyle(
                        //                 color: Colors.white, fontSize: 13),
                        //           ),
                        //         ),
                        //         const SizedBox(width: 5.0),
                        //         const Text(
                        //           '|',
                        //           style: TextStyle(color: Colors.white),
                        //         ),
                        //         const SizedBox(width: 5.0),
                        //         TextButton(
                        //           onPressed: () {
                        //             showDialog(
                        //               context: context,
                        //               builder: (ctx) => AlertDialog(
                        //                 title: const Text('알림'),
                        //                 content: const Text(
                        //                     '아직 개발 중인 기능입니다. 죄송합니다.'),
                        //                 actions: <Widget>[
                        //                   TextButton(
                        //                     child: const Text('확인'),
                        //                     onPressed: () {
                        //                       Navigator.of(ctx).pop();
                        //                     },
                        //                   ),
                        //                 ],
                        //               ),
                        //             );
                        //           },
                        //           child: const Text(
                        //             '비밀번호 찾기',
                        //             style: TextStyle(
                        //                 color: Colors.white, fontSize: 13),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // IconButton(
                                //   icon: Image.asset(
                                //       'assets/images/google_login_logo.png'),
                                //   onPressed: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (ctx) => AlertDialog(
                                //         title: const Text('알림'),
                                //         content: const Text(
                                //             '아직 개발 중인 기능입니다. 죄송합니다.'),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             child: const Text('확인'),
                                //             onPressed: () {
                                //               Navigator.of(ctx).pop();
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                // IconButton(
                                //   icon: Image.asset(
                                //       'assets/images/naver_login_logo.png'),
                                //   onPressed: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (ctx) => AlertDialog(
                                //         title: const Text('알림'),
                                //         content: const Text(
                                //             '아직 개발 중인 기능입니다. 죄송합니다.'),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             child: const Text('확인'),
                                //             onPressed: () {
                                //               Navigator.of(ctx).pop();
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                IconButton(
                                  icon: Image.asset(
                                      'assets/images/apple_login_logo.png'),
                                  onPressed: () => loginWithApple(context, ref),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                      'assets/images/kakao_login_logo.png'),
                                  onPressed: () => loginWithKakao(context, ref),
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
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              // ignore: prefer_const_constructors
                              child: Text(
                                '회원가입>',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  // decoration:
                                  //     TextDecoration.underline, // 텍스트에 밑줄 추가
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
    );
  }
}
