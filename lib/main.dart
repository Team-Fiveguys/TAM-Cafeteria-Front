import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tam_cafeteria_front/firebase_options.dart';
import 'package:tam_cafeteria_front/provider/access_token_provider.dart';
import 'package:tam_cafeteria_front/provider/login_state_provider.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tam_cafeteria_front/screens/login_screen.dart';
import 'package:tam_cafeteria_front/screens/menu_suggestion_board_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:tam_cafeteria_front/screens/admin_screen.dart';
import 'package:tam_cafeteria_front/screens/main_screen.dart';
import 'package:tam_cafeteria_front/screens/my_page_screen.dart';
import 'package:tam_cafeteria_front/screens/notification_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_dotenv/flutter_dotenv.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('backgroundHandler : ${message.data}');
  await ApiService.postNotificationToServer(message.data["id"]);
  // showNotification(message);
  // 세부 내용이 필요한 경우 추가...
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  // 액션 추가... 파라미터는 details.payload 방식으로 전달
}

void initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    ),
    onDidReceiveNotificationResponse: (details) {
      // 액션 추가...
    },
    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    print('onMessage listen: ${message.data}');

    if (notification != null) {
      await ApiService.postNotificationToServer(message.data["id"] ?? "0");
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
              color: Color(0xFFFFFFFF),
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 1,
            ),
          ),
          payload: message.data['test_paremeter1']);

      print("수신자 측 메시지 수신");
    }
  });

  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...
  }
}

Future<void> getToken() async {
  String? token;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 플랫폼 별 토큰 가져오기
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    token = await messaging.getAPNSToken();
  } else {
    token = await messaging.getToken();
  }

  print('FCM Token: $token');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String? initialToken =
      await TokenManagerWithSP.loadToken(); // SharedPreferences에서 토큰 로드
  await dotenv.load(fileName: 'assets/config/.env');
  final yourNativeAppKey = dotenv.env['NATIVE_APP_KEY']!; // .env에서 AppKey 로드
  final yourJavascriptAppKey =
      dotenv.env['JAVASCRIPT_APP_KEY']!; // .env에서 AppKey 로드
  KakaoSdk.init(
    nativeAppKey: yourNativeAppKey,
    javaScriptAppKey: yourJavascriptAppKey,
  );
  await Firebase.initializeApp();
  await getToken();

  runApp(
    ProviderScope(
      overrides: [
        //  Fixed the provider override with a function
        accessTokenProvider.overrideWith(
          (ref) => AccessTokenNotifier(initialToken),
        ),
      ],
      child: const App(),
    ),
  );
  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool isAdmin = false;
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  bool switchOn = false;
  int testValue = 1;
  bool isLoading = false;
  DateTime? currentBackPressTime;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isVisible = ValueNotifier(true);
  // final bool _isVisible = true;

  List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    const MenuBoardScreen(),
    const MyPage(),
  ];

  Future<void> initiallizingFCM() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    initializeNotification();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcmToken $fcmToken");
    // if (await Permission.notification.isDenied) {
    //   print('니녀석이냐?');
    //   await Permission.notification.request();
    // }

    bool hasPrompted = prefs.getBool('hasPromptedForNotification') ?? false;

    if (!hasPrompted) {
      // 알림 권한 요청
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        badge: true,
        alert: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('이녀석은 되냐?');
        // 사용자가 알림을 허용했을 때의 처리
        // 예: 서버에 API 호출
        // 매 로그인마다 post 호출 -> 알림 설정 초기화
        // 초기화 안되려면? get을 호출해서 있으면 post 안하고
        try {
          Map<String, bool> hasSetting =
              await ApiService.getNotificationSettings();

          if (fcmToken != null) {
            if (hasSetting.isEmpty) {
              await ApiService.postNotificationSet(fcmToken);
            } else if (fcmToken != await ApiService.getRegistrationToken()) {
              await ApiService.putRegistrationToken(fcmToken);
              await ApiService.updateNotificationSettings(hasSetting);
            }
          }
        } on Exception catch (e) {
          setState(() {
            isLoading = false;
          });
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
        await prefs.setBool('hasPromptedForNotification', true);
      }

      // 알림 설정 프롬프트가 표시되었음을 저장
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("New Device Token: $newToken");
      // 여기서 서버에 새 토큰을 업데이트하는 로직을 구현하세요.
      await ApiService.putRegistrationToken(newToken);
      await prefs.setBool('hasPromptedForNotification', true);
    });
    setState(() {
      isLoading = false;
    });
  }

  void switchMypage() {
    //어드민에서 호출
    setState(() {
      switchOn = true;
      isAdmin = false;
    });
  }

  void switchAdminPage() {
    //마이페이지에서 호출
    setState(() {
      switchOn = false;
    });
  }

  void decodeJwt(String? token) {
    if (token == null) {
      setState(() {
        isAdmin = false;
        _selectedIndex = 0;
      });
      return;
    }
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var decoded = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(decoded);
    // print('main App : decodeJwt : payloadMap $payloadMap');
    setState(() {
      isAdmin = payloadMap['role'] == "ADMIN";
    });
  }

  void _autoLoginCheck() {
    final token = ref.watch(accessTokenProvider);
    print("_autoLoginCheck: $token");
    if (token != null) {
      decodeJwt(token);
      ref.read(loginStateProvider.notifier).login();
      setState(() {
        print('autoLoginCheck :: $token');

        _selectedIndex = isAdmin ? 2 : 0;
        _widgetOptions = <Widget>[
          MainScreen(),
          const MenuBoardScreen(),
          isAdmin
              ? AdminPage(
                  testValue: testValue,
                  switchMypage: switchMypage,
                )
              : MyPage(
                  switchOn: switchOn,
                  switchAdmin: switchAdminPage,
                ),
        ];
      });
    } else {
      setState(() {
        isAdmin = false;
        _selectedIndex = isAdmin ? 2 : 0;
        _widgetOptions = <Widget>[
          MainScreen(),
          const MenuBoardScreen(),
          isAdmin
              ? AdminPage(
                  testValue: testValue,
                  switchMypage: switchMypage,
                )
              : MyPage(
                  switchOn: switchOn,
                  switchAdmin: switchAdminPage,
                ),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _permissionWithNotification();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _isVisible.value = false;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _isVisible.value = true;
      }
    });
    Future.delayed(Duration.zero, () async {
      _autoLoginCheck();
      final isLoggedIn = ref.watch(loginStateProvider);
      if (isLoggedIn) {
        await initiallizingFCM();
      }
    });
    _selectedIndex = isAdmin ? 2 : 0;
    _widgetOptions = <Widget>[
      MainScreen(),
      const MenuBoardScreen(),
      isAdmin
          ? AdminPage(
              testValue: testValue,
              switchMypage: switchMypage,
            )
          : MyPage(
              switchOn: switchOn,
              switchAdmin: switchAdminPage,
            ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isVisible.dispose();
    super.dispose();
  }

  // 사용자가 탭을 선택했을 때 호출되는 함수
  void _onItemTapped(int index, BuildContext context) {
    final isLoggedIn = ref.watch(loginStateProvider);
    if (index != 0 && !isLoggedIn) {
      // 홈이 아닌 다른 탭을 선택하고, isToken이 false라면
      navigateToLoginScreen(context);
    } else {
      setState(() {
        _selectedIndex = index; // 선택된 탭의 인덱스를 업데이트
      });
    }
  }

  Future<void> navigateToLoginScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    print('main : navigateToLogin : $result');
    if (result != null) {
      final isLoggedIn = ref.watch(loginStateProvider);
      if (isLoggedIn) {
        await initiallizingFCM();
      }
      // setState(() {});
    }
  }

  Future<int> getNotificationLength() async {
    final isLoggedIn = ref.watch(loginStateProvider);
    if (isLoggedIn) {
      final list = await ApiService.getNotifications();
      int count = 0;
      for (var noti in list) {
        if (!noti.isRead) {
          count++;
        }
      }
      return count;
    }
    return 0;
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    if (currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime!) >
            const Duration(seconds: 2)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 15,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;

    // SystemNavigator.pop();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print('build :: ${ref.watch(loginStateProvider)}');
    final accessToken = ref.watch(accessTokenProvider);
    if (!switchOn) {
      decodeJwt(accessToken);
    }

    // print("main App :: build: accessToken $accessToken");
    print("main App :: build: isAdmin $isAdmin");
    _widgetOptions = <Widget>[
      MainScreen(),
      const MenuBoardScreen(),
      isAdmin
          ? AdminPage(
              testValue: testValue,
              switchMypage: switchMypage,
            )
          : MyPage(
              switchOn: switchOn,
              switchAdmin: switchAdminPage,
            ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        dialogBackgroundColor: Colors.white,
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   secondary: const Color(0xFFFFF7E3),
        // ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF3e3e3e),
        primaryColorLight: const Color(0xFF97948f),
        primaryColorDark: const Color(0xFF515151),
        dividerColor: const Color(0xFFc6c6c6),
        cardColor: const Color(0xFFFFDA7B),
        canvasColor: const Color(0xFF002967),
        appBarTheme: const AppBarTheme(
          // elevation: 5,
          scrolledUnderElevation: 3,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10), // 하단 모서리의 반경을 30으로 설정
            ),
          ),
        ),
        indicatorColor: Colors.white,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.blue,
            circularTrackColor: Colors.white,
            refreshBackgroundColor: Colors.white),
      ),
      home: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: AnimatedBuilder(
              animation: _isVisible,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isVisible.value ? 56.0 : 0.0,
                  child: Wrap(
                    children: [
                      BottomNavigationBar(
                        backgroundColor: Colors.white,
                        items: <BottomNavigationBarItem>[
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: '홈',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.forum),
                            label: '게시판',
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.person),
                            label: isAdmin ? '관리자페이지' : '마이페이지',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        selectedItemColor: Colors.amber[800],
                        onTap: (index) => _onItemTapped(index, context),
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: _selectedIndex == 1
                ? Builder(
                    builder: (context) {
                      return FloatingActionButton.extended(
                        onPressed: () {
                          // FloatingActionButton을 누를 때 수행할 작업
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('알림'),
                              content: const Text('아직 개발 중인 기능입니다. 죄송합니다.'),
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const WriteMenuScreen(),
                          //   ),
                          // );
                        },
                        icon: Image.asset(
                          'assets/images/write_board_icon.png',
                          width: 70, // 이미지의 너비 조절
                          height: 70, // 이미지의 높이 조절
                        ),
                        label: const Text(''), // 라벨은 비워둠
                        backgroundColor:
                            Colors.black, // 배경색을 투명으로 설정하여 이미지만 보이도록 함
                        shape: const CircleBorder(), // 원형으로 설정
                      );
                    },
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            appBar: AppBar(
              // elevation: 100,
              scrolledUnderElevation: 3,
              backgroundColor: Colors.white,
              leading: Opacity(
                // 투명한 아이콘 버튼 추가
                opacity: 0,
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        // FirebaseMessaging.instance.subscribeToTopic('1');
                        // FirebaseMessaging.instance.subscribeToTopic('today_diet');
                        // ref.read(loginStateProvider.notifier).logout();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LoginScreen(), //알람 버튼
                        //   ),
                        // );
                      }, // 아무것도 하지 않음
                    );
                  },
                ),
              ),
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () async {
                        // ApiService.delAutoLogin();
                        final isLoggedIn = ref.watch(loginStateProvider);
                        if (!isLoggedIn) {
                          navigateToLoginScreen(context);
                        } else {
                          bool result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationCenter()));

                          if (result == true) {
                            // 필요한 상태 업데이트나 리렌더링 로직
                            setState(() {
                              getNotificationLength();
                            });
                          }
                        }
                      },
                      icon: FutureBuilder(
                        future: getNotificationLength(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null || snapshot.data == 0) {
                            return const Icon(Icons.notifications);
                          }
                          return badges.Badge(
                            badgeContent: Text(
                              snapshot.data!.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            position: badges.BadgePosition.topEnd(
                              top: -8,
                              end: -3,
                            ),
                            child: const Icon(Icons.notifications),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    // Expanded로 Row의 자식을 감싸서 중앙 정렬 유지
                    child: SizedBox(
                      height: 50,
                      child: Image.asset(
                        'assets/images/app_bar_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: WillPopScope(
              onWillPop: onWillPop,
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    testValue = 2;
                  });
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ),
          ),
          isLoading ? _buildLoadingScreen() : Container(),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.black.withOpacity(0.5), // 전체 화면을 어둡게 하여 로딩 인디케이터를 부각
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ), // 로딩 인디케이터
      ),
    );
  }
}
