import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';
import 'package:tam_cafeteria_front/provider/login_state_provider.dart';
// import 'package:tam_cafeteria_front/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:tam_cafeteria_front/screens/terms_screen.dart';
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
  String? name;
  String? email;
  Future<void> getMyInfo() async {
    final info = await ApiService.getUserInfo();
    if (info != null) {
      name = info['name'] ?? "익명";
      email = info['email'] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 90,
                child: FutureBuilder(
                  future: getMyInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      // 에러 발생 시
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 90,
                          ), // Assuming you want a person icon
                          const SizedBox(
                              width: 8), // Adjust as needed for spacing
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '안녕하세요 $name님',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$email'),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              // const SizedBox(height: 20),
              // buildButtonWithPasswordDialog(
              //   context,
              //   '비밀번호 변경',
              // ),
              // const SizedBox(height: 20),
              // buildButtonWithNicknameDialog(
              //   context,
              //   '닉네임 수정',
              // ),
              const SizedBox(height: 20),
              const NotificationSettingsDialog(
                buttonText: '알림 설정',
              ),
              const SizedBox(height: 20),
              buildTermsWithDialog(
                context,
                '약관 보기',
              ),
              const SizedBox(height: 20),
              buildLicensesWithDialog(
                context,
                '오픈소스 라이센스 보기',
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
                          ApiService.deleteLogOut();
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
              const SizedBox(
                height: 50,
              ),
              const Text(
                '건의 및 문의사항 : tamcafeteria@gmail.com',
                style: TextStyle(fontWeight: FontWeight.bold),
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
        child: Consumer(
          builder: (context, ref, child) => ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(buttonText),
                    content: const Text('정말로 탈퇴하시겠습니까?'),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          print('회원 탈퇴 처리');
                          try {
                            await ApiService.deleteUser();

                            ref.read(loginStateProvider.notifier).logout();
                            // 로그아웃 후의 추가 작업
                            // Navigator.pushReplacementNamed(
                            //     context, '/loginScreen'); // 로그인 화면으로 이동
                            if (widget.switchOn ?? false) {
                              widget.switchAdmin!();
                            }
                            Navigator.of(context).pop();
                            setState(() {});
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
                          // Close the dialog
                          // Navigator.of(context).pop();
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
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Theme.of(context).canvasColor)),
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
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).canvasColor)),
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

  Widget buildTermsWithDialog(BuildContext context, String buttonText) {
    return Center(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).canvasColor)),
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

  Widget buildLicensesWithDialog(BuildContext context, String buttonText) {
    return Center(
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: ElevatedButton(
          onPressed: () {
            showLicensePage(
              context: context,
              // 필요한 경우 applicationName, applicationVersion 등을 설정할 수 있음
              applicationName: '탐식당',
              applicationVersion: '2.0.0',
              applicationIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/app_logo.png',
                    width: 100, height: 100),
              ),
              applicationLegalese: '© 2024 탐나는 식탁',
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).canvasColor)),
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
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Theme.of(context).canvasColor)),
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
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).canvasColor)),
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
