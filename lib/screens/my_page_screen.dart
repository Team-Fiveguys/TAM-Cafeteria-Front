import 'package:flutter/material.dart';
import 'package:tam_cafeteria_front/provider/login_state_provider.dart';
import 'package:tam_cafeteria_front/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 56,
          color: Theme.of(context).canvasColor,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '마이페이지',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2.0,
                blurRadius: 1.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 100,
                  ), // Assuming you want a person icon
                  SizedBox(width: 8), // Adjust as needed for spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '안녕하세요 00님 학식 맛있게 드세요!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('닉네임'),
                      Text('sssss@naver.com'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildButtonWithPasswordDialog(context, '비밀번호 수정'),
              const SizedBox(height: 10),
              buildButtonWithNicknameDialog(context, '닉네임 수정'),
              const SizedBox(height: 10),
              buildButtonWithDialog(context, '이메일 수정', '이메일 수정 내용'),
              const SizedBox(height: 10),
              buildButtonWithDialog(context, '약관보기', '약관보기 내용'),
              const SizedBox(height: 60),
              buildButtonWithDialog(context, '회원 탈퇴', '회탈'),
              const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {
              //     // 로그아웃 버튼을 눌렀을 때 실행되는 로그아웃 기능
              //     ref.read(loginStateProvider.notifier).logout();
              //     // 로그아웃 후의 추가 작업
              //     Navigator.pushReplacementNamed(
              //         context, '/loginScreen'); // 로그인 화면으로 이동
              //   },
              //   child: const Text('로그아웃'),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButtonWithDialog(
      BuildContext context, String buttonText, String dialogContent) {
    return Center(
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
        ),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(buttonText),
                  content: Text(dialogContent),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('닫기'),
                    ),
                  ],
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonWithNicknameDialog(
      BuildContext context, String buttonText) {
    TextEditingController nicknameController = TextEditingController();

    return Center(
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
        ),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(buttonText),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nicknameController,
                        decoration: const InputDecoration(labelText: '변경 닉네임'),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement logic to handle nickname change here
                        String newNickname = nicknameController.text;

                        // For demonstration purposes, let's just print the entered nickname
                        print('New Nickname: $newNickname');

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Text('저장'),
                    ),
                  ],
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonWithPasswordDialog(
      BuildContext context, String buttonText) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController =
        TextEditingController();

    return Center(
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
        ),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(buttonText),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: currentPasswordController,
                        decoration: const InputDecoration(labelText: '현재 비밀번호'),
                        obscureText: true,
                      ),
                      TextField(
                        controller: newPasswordController,
                        decoration:
                            const InputDecoration(labelText: '새로운 비밀번호'),
                        obscureText: true,
                      ),
                      TextField(
                        controller: confirmNewPasswordController,
                        decoration:
                            const InputDecoration(labelText: '새로운 비밀번호 확인'),
                        obscureText: true,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement logic to handle password change here
                        String currentPassword = currentPasswordController.text;
                        String newPassword = newPasswordController.text;
                        String confirmNewPassword =
                            confirmNewPasswordController.text;

                        // Validate and process the password change
                        // For demonstration purposes, let's just print the entered passwords
                        print('Current Password: $currentPassword');
                        print('New Password: $newPassword');
                        print('Confirm New Password: $confirmNewPassword');

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Text('저장'),
                    ),
                  ],
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
