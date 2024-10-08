//체크박스 상호작용
//배경색
//남성여성, 회원가입 버튼 디자인
//sizebox 객체로 만들고? 텍스트인풋 객체화
//닉네임 위쪽패딩
//각자 다 패딩 넣고
//남성 여성 버튼 패딩과 동그랗게
//약관 동의 맨 아래 붙힌다.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible = false;
  bool _checkpasswordVisible = false;
  bool _isServiceChecked = false;
  bool _isPersonalChecked = false;
  bool isVerified = false;
  // String? _selectedGender;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController checkEmailVerifiyControlloer =
      TextEditingController();
  bool _passwordsMatch = true;

  bool isSendCode = false;

  Timer? _timer;
  int _start = 180; // 3분

  void signUp() async {
    bool success = false;
    String msg = "";
    if (!_isServiceChecked || !_isPersonalChecked) {
      msg = "약관 동의를 해주세요";
    } else if (nameController.text.isEmpty) {
      msg = "이름을 입력해주세요";
    } else if (_passwordController.text.isEmpty) {
      msg = "비밀번호를 입력해주세요";
    } else if (_checkPasswordController.text.isEmpty) {
      msg = "비밀번호를 확인해주세요";
    } else if (_passwordController.text != _checkPasswordController.text) {
      msg = "비밀번호가 일치하지않습니다";
    } else if (!isVerified) {
      msg = "메일을 인증해주세요";
    } else {
      try {
        success = await ApiService.postSignUp(
            nameController.text,
            _passwordController.text,
            emailController.text,
            checkEmailVerifiyControlloer.text);
        if (success) {
          msg = "회원가입 성공";
        } else {
          msg = "회원가입 실패";
        }
      } on Exception catch (e) {
        msg = e.toString();
      }
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(msg),
                ElevatedButton(
                  child: const Text('닫기'),
                  onPressed: () {
                    Navigator.pop(context);
                    if (success) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void sendEmailCode(BuildContext context) async {
    String email = emailController.text;
    String message = "";
    try {
      message = await ApiService.postEmailAuthCode(email);
      if (message == 'true') {
        startTimer();
        if (mounted) {
          setState(() {
            isSendCode = true;
          });
        }
      } else {
        _timer?.cancel();
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("알림"),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Alert Dialog 창을 닫습니다.
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } on Exception catch (e) {
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
  }

  void checkEmailVerification(BuildContext context) async {
    print(_start);
    if (_start == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("알림"),
            content: const Text("3분이 지났으므로 인증 코드를 재발급해주세요."),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // Alert Dialog 창을 닫습니다.
                },
              ),
            ],
          );
        },
      );
      return;
    }
    String email = emailController.text;
    String authCode = checkEmailVerifiyControlloer.text;
    isVerified = await ApiService.postEmailVerification(email, authCode);
    late String message;
    if (isVerified) {
      message = "확인되었습니다";
      _timer?.cancel();
    } else {
      message = "인증 코드가 올바르지 않습니다. 다시 확인해주세요";
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message),
                ElevatedButton(
                  child: const Text('닫기'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel();
    _start = 180; // 이전 타이머가 있다면 취소
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minute = seconds ~/ 60;
    int second = seconds % 60;
    return "$minute:${second.toString().padLeft(2, '0')}";
  }

  // Widget _buildGenderButton(String gender) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       minimumSize: const Size(100, 70),
  //       backgroundColor: _selectedGender == gender ? Colors.grey : Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _selectedGender = gender;
  //       });
  //     },
  //     child: Text(
  //       gender,
  //       style: TextStyle(
  //         color: _selectedGender == gender ? Colors.white : Colors.black,
  //       ),
  //     ),
  //   );
  // }

  Future<String> loadServiceTerms() async {
    return await rootBundle.loadString('assets/serviceTerms.txt');
  }

  Future<String> loadPersonalTerms() async {
    return await rootBundle.loadString('assets/personalTerms.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xff002967),
          border: Border.all(
            color: Colors.grey, // 테두리 색상 지정
          ),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    right: 15,
                    left: 15,
                  ),
                  child: TextField(
                    controller: nameController,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                      hintText: '이름',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: InputDecoration(
                            hintText: '이메일',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // 모서리를 둥글게
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () => sendEmailCode(context),
                        child: const Text(
                          '인증 발송',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSendCode)
                  Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  TextField(
                                    controller: checkEmailVerifiyControlloer,
                                    decoration: InputDecoration(
                                      hintText: '이메일 인증 코드',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // 모서리를 둥글게
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 12.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      widthFactor: 1.0,
                                      child: Text(
                                        formatTime(_start),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () => checkEmailVerification(context),
                              child: const Text(
                                '인증 확인',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          // 상단 Container: 하단 외곽선을 제외한 세 면에 외곽선을 적용합니다.
                          // border: Border(
                          //   top: BorderSide(color: Colors.grey),
                          //   left: BorderSide(color: Colors.grey),
                          //   right: BorderSide(color: Colors.grey),
                          // ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              // 기본 테마를 무시하고 InputBorder를 없앰
                              border: InputBorder.none,
                              filled: false,
                            ),
                          ),
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            controller: _passwordController,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                              hintText: '비밀번호',
                              contentPadding: const EdgeInsets.all(12),
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          // border: Border(
                          //   left: BorderSide(color: Colors.grey),
                          //   right: BorderSide(color: Colors.grey),
                          // ),
                          color: Colors.white,
                        ),
                        child: const Divider(
                          color: Colors.black,
                          thickness: 0.8,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          // 하단 Container: 상단 외곽선을 제외한 세 면에 외곽선을 적용합니다.
                          // border: Border(
                          //   bottom: BorderSide(color: Colors.grey),
                          //   left: BorderSide(color: Colors.grey),
                          //   right: BorderSide(color: Colors.grey),
                          // ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  // 기본 테마를 무시하고 InputBorder를 없앰
                                  border: InputBorder.none,
                                  filled: false,
                                ),
                              ),
                              child: TextFormField(
                                obscureText: !_checkpasswordVisible,
                                controller: _checkPasswordController,
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                onChanged: (value) {
                                  setState(() {
                                    _passwordsMatch =
                                        _passwordController.text == value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: '비밀번호 확인',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                  filled: false,
                                  suffixIcon: IconButton(
                                    icon: Icon(_checkpasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(
                                        () {
                                          _checkpasswordVisible =
                                              !_checkpasswordVisible;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            if (!_passwordsMatch) // 일치하지 않을 때에만 출력
                              const Divider(
                                color: Colors.black,
                                thickness: 0.8,
                              ),
                            if (!_passwordsMatch)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  '비밀번호가 일치하지 않습니다.',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 30,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     left: 15,
                //     right: 15,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: _buildGenderButton('남성'),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Expanded(
                //         child: _buildGenderButton('여성'),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey, // 원하는 색상을 여기에 지정
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0), // 필요에 따라 반경 조절
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('약관동의'),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isServiceChecked,
                              onChanged: (bool? value) {
                                // 체크박스 상태 변경
                                setState(() {
                                  _isServiceChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('서비스 이용 약관 동의'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColorLight),
                                borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            height: 200,
                            child: FutureBuilder<String>(
                              future: loadServiceTerms(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return SingleChildScrollView(
                                    child: Text(snapshot.data ??
                                        'Failed to load terms.'),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isPersonalChecked,
                              onChanged: (bool? value) {
                                // 체크박스 상태 변경
                                setState(() {
                                  _isPersonalChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('개인정보 수집 동의'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColorLight),
                                borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            height: 200,
                            child: FutureBuilder<String>(
                              future: loadPersonalTerms(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return SingleChildScrollView(
                                    child: Text(snapshot.data ??
                                        'Failed to load terms.'),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0186d1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                0,
              ),
            ),
            minimumSize: const Size(double.infinity, 60),
          ),
          onPressed: signUp,
          child: const Text(
            '회원가입',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
