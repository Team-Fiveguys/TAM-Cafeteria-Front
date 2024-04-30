import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tam_cafeteria_front/firebase_options.dart';
import 'package:tam_cafeteria_front/notification/local_notification.dart';
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
import 'package:tam_cafeteria_front/screens/write_menu_screen.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';
import 'package:badges/badges.dart' as badges;

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
      iOS: DarwinInitializationSettings(),
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
    await ApiService.postNotificationToServer(message.data["id"]);
    if (notification != null) {
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
            iOS: DarwinNotificationDetails(),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String? initialToken =
      await TokenManagerWithSP.loadToken(); // SharedPreferences에서 토큰 로드

  const yourNativeAppKey = 'bb9947b8eee4ce125f6b8f4c94ed878c';
  const yourJavascriptAppKey = '46db4c796ce7d09bbbbe0fd7d628ef4b';
  KakaoSdk.init(
    nativeAppKey: yourNativeAppKey,
    javaScriptAppKey: yourJavascriptAppKey,
  );

  await initiallizingFCM();

  initializeNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
}

Future<void> initiallizingFCM() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  // await initializeNotifications();
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    badge: true,
    alert: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // 사용자가 알림 권한을 허용했을 때
    // 여기에서 API 호출 로직을 추가하세요.
    if (fcmToken != null) {
      await ApiService.postNotificationSet(fcmToken);
    }
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    // 사용자가 잠정적으로 알림을 허용했을 때
    // 필요한 경우 여기에 로직을 추가하세요.
  } else {
    // 사용자가 알림 권한을 거부했을 때
    // 필요한 경우 여기에 로직을 추가하세요.
  }
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool isAdmin = false;
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스

  int testValue = 1;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isVisible = ValueNotifier(true);
  // final bool _isVisible = true;

  List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    const MenuBoardScreen(),
    const MyPage(),
  ];

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
                )
              : const MyPage(),
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
                )
              : const MyPage(),
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
    Future.delayed(Duration.zero, () {
      _autoLoginCheck();
    });
    _selectedIndex = isAdmin ? 2 : 0;
    _widgetOptions = <Widget>[
      MainScreen(),
      const MenuBoardScreen(),
      isAdmin
          ? AdminPage(
              testValue: testValue,
            )
          : const MyPage(),
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
      setState(() {});
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print('build :: ${ref.watch(loginStateProvider)}');
    final accessToken = ref.watch(accessTokenProvider);
    decodeJwt(accessToken);

    // print("main App :: build: accessToken $accessToken");
    // print("main App :: build: isAdmin $isAdmin");
    _widgetOptions = <Widget>[
      MainScreen(),
      const MenuBoardScreen(),
      isAdmin
          ? AdminPage(
              testValue: testValue,
            )
          : const MyPage(),
    ];
    return MaterialApp(
      theme: ThemeData(
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
              refreshBackgroundColor: Colors.white)),
      home: Scaffold(
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
            }),
        floatingActionButton: _selectedIndex == 1
            ? Builder(builder: (context) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    // FloatingActionButton을 누를 때 수행할 작업
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WriteMenuScreen(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/write_board_icon.png',
                    width: 100, // 이미지의 너비 조절
                    height: 100, // 이미지의 높이 조절
                  ),
                  label: const Text(''), // 라벨은 비워둠
                  backgroundColor: Colors.black, // 배경색을 투명으로 설정하여 이미지만 보이도록 함
                  shape: const CircleBorder(), // 원형으로 설정
                );
              })
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          // elevation: 100,
          scrolledUnderElevation: 3,
          backgroundColor: Colors.white,
          leading: Opacity(
            // 투명한 아이콘 버튼 추가
            opacity: 0,
            child: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // FirebaseMessaging.instance.subscribeToTopic('1');
                  // FirebaseMessaging.instance.subscribeToTopic('today_diet');
                  ref.read(loginStateProvider.notifier).logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(), //알람 버튼
                    ),
                  );
                }, // 아무것도 하지 않음
              );
            }),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () async {
                  // ApiService.delAutoLogin();
                  bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationCenter()));

                  if (result == true) {
                    // 필요한 상태 업데이트나 리렌더링 로직
                    setState(() {
                      getNotificationLength();
                    });
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
                    }),
              );
            }),
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
        body: RefreshIndicator(
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
    );
  }
}
