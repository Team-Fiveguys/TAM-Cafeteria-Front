import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:tam_cafeteria_front/provider/login_state_provider.dart';
import 'package:tam_cafeteria_front/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:tam_cafeteria_front/widgets/notification_settings_dialog.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key, this.switchOn, this.switchAdmin}) : super(key: key);

  final bool? switchOn;
  final Function? switchAdmin;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool overallAlarm = false;
  bool restaurantAlarm = false;
  bool featureAlarm = false;

  @override
  Widget build(BuildContext context) {
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
        if (widget.switchOn ?? false)
          TextButton(
            onPressed: () => widget.switchAdmin!(),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).canvasColor,
                  size: 15,
                ),
                Text(
                  '관리자 페이지',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          )
        else
          const SizedBox(
            height: 30,
          ),
        Container(
          margin: const EdgeInsets.all(11),
          padding: const EdgeInsets.all(35),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 90,
                  ), // Assuming you want a person icon
                  SizedBox(width: 8), // Adjust as needed for spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '안녕하세요 00님',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('sssss@naver.com'),
                      Text('성별'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildButtonWithPasswordDialog(
                context,
                '비밀번호 변경',
              ),
              const SizedBox(height: 20),
              buildButtonWithNicknameDialog(
                context,
                '닉네임 수정',
              ),
              const SizedBox(height: 20),
              const NotificationSettingsDialog(
                buttonText: '알림 설정',
              ),
              const SizedBox(height: 20),
              buildButtonWithWithdrawDialog(
                context,
                '회원 탈퇴',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffffb800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          // 로그아웃 버튼을 눌렀을 때 실행되는 로그아웃 기능
                          ref.read(loginStateProvider.notifier).logout();
                          // 로그아웃 후의 추가 작업
                          // Navigator.pushReplacementNamed(
                          //     context, '/loginScreen'); // 로그인 화면으로 이동
                          if (widget.switchOn ?? false) {
                            widget.switchAdmin!();
                          }
                          setState(() {});
                        },
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButtonWithWithdrawDialog(
      BuildContext context, String buttonText) {
    return Center(
      child: Container(
        height: 55,
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
                  content: const Text('정말로 탈퇴하시겠습니까?'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Implement logic for withdrawal here
                        // This is just a placeholder for demonstration
                        print('회원 탈퇴 처리');

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffb800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '네',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x00000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '아니요',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffc6c6c6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonWithDialog(
      BuildContext context, String buttonText, String dialogContent) {
    return Center(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffc6c6c6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
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
      // width: 300,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
      ),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Material(
                type: MaterialType.transparency,
                child: Center(
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '000님-탐식당',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          buttonText,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.black54),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Center(
                                  child: SizedBox(
                                    child: TextField(
                                      controller: nicknameController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16),
                                            ),
                                          ),
                                          labelText: '현재 닉네임'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Implement logic to handle nickname change here
                                        String newNickname =
                                            nicknameController.text;

                                        // For demonstration purposes, let's just print the entered nickname
                                        print('New Nickname: $newNickname');

                                        // Close the dialog
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffffb800),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: const Text(
                                        '저장',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffc6c6c6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ));
  }

  Widget buildButtonWithPasswordDialog(
    BuildContext context,
    String buttonText,
  ) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController =
        TextEditingController();

    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmNewPassword = true;
    bool passwordsMatch = true;

    return Center(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
        ),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Material(
                      type: MaterialType.transparency,
                      child: Center(
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(30.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '000님-탐식당',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.black54),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                buttonText,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller:
                                                currentPasswordController,
                                            decoration: InputDecoration(
                                              labelText: '현재 비밀번호',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black54),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  obscureCurrentPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    obscureCurrentPassword =
                                                        !obscureCurrentPassword;
                                                  });
                                                },
                                              ),
                                            ),
                                            obscureText: obscureCurrentPassword,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Center(
                                        child: SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller: newPasswordController,
                                            decoration: InputDecoration(
                                              labelText: '새로운 비밀번호',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black54),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  obscureNewPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    obscureNewPassword =
                                                        !obscureNewPassword;
                                                  });
                                                },
                                              ),
                                            ),
                                            obscureText: obscureNewPassword,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Center(
                                        child: SizedBox(
                                          width: 260,
                                          child: TextField(
                                            controller:
                                                confirmNewPasswordController,
                                            decoration: InputDecoration(
                                              labelText: '새로운 비밀번호 확인',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black54),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  obscureConfirmNewPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    obscureConfirmNewPassword =
                                                        !obscureConfirmNewPassword;
                                                  });
                                                },
                                              ),
                                              errorText: !passwordsMatch
                                                  ? '비밀번호가 다릅니다'
                                                  : null,
                                            ),
                                            obscureText:
                                                obscureConfirmNewPassword,
                                            onChanged: (value) {
                                              setState(() {
                                                passwordsMatch =
                                                    newPasswordController
                                                            .text ==
                                                        value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Implement logic to handle password change here
                                              String currentPassword =
                                                  currentPasswordController
                                                      .text;
                                              String newPassword =
                                                  newPasswordController.text;
                                              String confirmNewPassword =
                                                  confirmNewPasswordController
                                                      .text;

                                              // Validate and process the password change
                                              // For demonstration purposes, let's just print the entered passwords
                                              print(
                                                  'Current Password: $currentPassword');
                                              print(
                                                  'New Password: $newPassword');
                                              print(
                                                  'Confirm New Password: $confirmNewPassword');

                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xffffb800),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: const Text(
                                              '저장',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffc6c6c6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
