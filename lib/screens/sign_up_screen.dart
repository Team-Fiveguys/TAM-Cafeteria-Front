//체크박스 상호작용
//배경색
//남성여성, 회원가입 버튼 디자인
//sizebox 객체로 만들고? 텍스트인풋 객체화
//닉네임 위쪽패딩
//각자 다 패딩 넣고
//남성 여성 버튼 패딩과 동그랗게
//약관 동의 맨 아래 붙힌다.
import 'dart:js_util';

import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible = false;
  bool _checkpasswordVisible = false;
  bool _isChecked = false;
  String? _selectedGender;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkPasswordController =
      TextEditingController();
  bool _passwordsMatch = true;

  Widget _buildGenderButton(String gender) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100, 70),
        backgroundColor: _selectedGender == gender ? Colors.grey : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Text(
        gender,
        style: TextStyle(
          color: _selectedGender == gender ? Colors.white : Colors.black,
        ),
      ),
    );
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
                    right: 5,
                    left: 5,
                  ),
                  child: TextField(
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
                    right: 5,
                    left: 5,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '이메일',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      '이메일 중복 확인',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          // 상단 Container: 하단 외곽선을 제외한 세 면에 외곽선을 적용합니다.
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          obscureText: !_passwordVisible,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: '비밀번호',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                            filled: false,
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(
                                  () {
                                    _passwordVisible = !_passwordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
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
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: !_checkpasswordVisible,
                              controller: _checkPasswordController,
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
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildGenderButton('남성'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildGenderButton('여성'),
                      ),
                    ],
                  ),
                ),
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
                              value: _isChecked,
                              onChanged: (bool? value) {
                                // 체크박스 상태 변경
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('개인정보 수집 동의'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                // 체크박스 상태 변경
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('개인정보 수집 동의'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                // 체크박스 상태 변경
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('개인정보 수집 동의'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                // 체크박스 상태 변경
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('개인정보 수집 동의'),
                          ],
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
            minimumSize: const Size(double.infinity, 80),
          ),
          onPressed: () {
            // 회원가입 기능 구현
          },
          child: const Text(
            '회원가입',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
