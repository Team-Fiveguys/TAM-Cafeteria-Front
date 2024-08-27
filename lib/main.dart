import 'dart:async';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tam_cafeteria_front/provider/access_token_provider.dart';
import 'package:tam_cafeteria_front/provider/login_state_provider.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tam_cafeteria_front/screens/announcement_board_screen.dart';
import 'package:tam_cafeteria_front/screens/enter_board_screen.dart';
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
  // await ApiService.postNotificationToServer(message.data["id"]);
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

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    print('onMessage listen: ${message.data}');

    if (notification != null) {
      // await ApiService.postNotificationToServer(message.data["id"] ?? "0");
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

Future<String?> getToken() async {
  String? token;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 플랫폼 별 토큰 가져오기
  // if (defaultTargetPlatform == TargetPlatform.iOS) {
  //   token = await messaging.getAPNSToken();
  // } else {
  token = await messaging.getToken();
  // }
  return token;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  initializeNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  runApp(
    ProviderScope(
      overrides: [
        //  Fixed the provider override with a function
        accessTokenProvider.overrideWith(
          (ref) => AccessTokenNotifier(initialToken),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // GlobalKey 설정
        navigatorObservers: <NavigatorObserver>[observer],
        routes: {
          '/login': (context) => LoginScreen(), // 로그인 화면
          // 필요한 다른 라우트를 추가
        },
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(
                Theme.of(context).textTheme,
              ),
              checkboxTheme: CheckboxThemeData(
                side: const BorderSide(color: Colors.blue), // 테두리 색상 설정
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.blue; // 체크했을 때 색상 설정
                  }
                  return Colors.white; // 해제했을 때 색상 설정
                }),
                checkColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              dialogTheme: const DialogTheme(
                surfaceTintColor: Colors.white,
              ),
              textButtonTheme: const TextButtonThemeData(
                  style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.blue))),
              switchTheme: SwitchThemeData(
                trackColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    // 스위치가 켜져있을 때의 색상
                    return Colors.blue;
                  } else {
                    // 스위치가 꺼져있을 때의 색상
                    return Colors.grey;
                  }
                }),
              ),
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15), // 눌렀을 때 테두리 색상
                ),
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color(0xFF515151), // 커서 색상
                selectionColor: Colors.lightBlueAccent, // 선택한 텍스트 배경 색상
                selectionHandleColor: Colors.blue, // 선택 핸들 색상
              ),
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
                refreshBackgroundColor: Colors.white,
              ),
            ),
            child: child!,
          );
        },
        home: const App(),
      ),
    ),
  );
  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> with SingleTickerProviderStateMixin {
  bool isAdmin = false;
  bool isRealAdmin = false;
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  bool switchOn = false;
  int testValue = 1;
  bool isLoading = false;
  bool isNoti = false;
  String userId = "";
  DateTime? currentBackPressTime;
  bool hasError = false;

  bool _showBackToTopButton = false;

  late ScrollController _scrollControllerUp;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isVisible = ValueNotifier(true);
  // final bool _isVisible = true;

  AnimationController? _controller;
  OverlayEntry? _overlayEntry;

  GlobalKey<MenuBoardScreenState> menuBoardKey = GlobalKey();

  List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    MainScreen(),
    const MyPage(),
  ];

  Future<void> initiallizingFCM() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await Firebase.initializeApp();
    // initializeNotification();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

      String? fcmToken = await getToken();
      print("fcmToken $fcmToken");
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
              ApiService.postNotificationSet(fcmToken);
              // hasSetting = await ApiService.getNotificationSettings();
              // await ApiService.updateNotificationSettings(hasSetting);
            } else if (fcmToken != await ApiService.getRegistrationToken()) {
              ApiService.putRegistrationToken(fcmToken);
              // await ApiService.updateNotificationSettings(hasSetting);
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
      _isVisible.value = true;
    });
  }

  // @override
  // void disposeUp() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 3), curve: Curves.linear);
  }

  void switchAdminPage() {
    //마이페이지에서 호출
    setState(() {
      switchOn = false;
      _isVisible.value = true;
    });
  }

  void decodeJwt(String? token) {
    if (token == null) {
      setState(() {
        isRealAdmin = false;
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
    print(payloadMap);
    setState(() {
      isRealAdmin = payloadMap['role'] == "ADMIN";
      isAdmin = payloadMap['role'] == "ADMIN";
      userId = payloadMap['sub'].toString();
    });
  }

  void _autoLoginCheck() {
    final token = ref.watch(accessTokenProvider);
    // print("_autoLoginCheck: $token");
    if (token != null) {
      decodeJwt(token);
      ref.read(loginStateProvider.notifier).login();
      setState(() {
        print('autoLoginCheck :: $token');

        _selectedIndex = isAdmin ? 2 : 0; //TODO : 게시판 완성되면 2로 고치기
        _widgetOptions = <Widget>[
          MainScreen(),
          isNoti
              ? AnnounceBoardScreen(
                  isAdmin: isRealAdmin,
                  scrollVisible: _isVisible,
                )
              : MenuBoardScreen(
                  key: menuBoardKey,
                  userId: userId,
                  isAdmin: isRealAdmin,
                  scrollVisible: _isVisible,
                ),
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
        isRealAdmin = false;
        isAdmin = false;
        _selectedIndex = isAdmin ? 2 : 0;
        _widgetOptions = <Widget>[
          MainScreen(),
          isNoti
              ? AnnounceBoardScreen(
                  isAdmin: isRealAdmin,
                  scrollVisible: _isVisible,
                )
              : MenuBoardScreen(
                  key: menuBoardKey,
                  userId: userId,
                  isAdmin: isRealAdmin,
                  scrollVisible: _isVisible,
                ),
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

    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      vsync: this,
    );
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
      isNoti
          ? AnnounceBoardScreen(
              isAdmin: isRealAdmin,
              scrollVisible: _isVisible,
            )
          : MenuBoardScreen(
              key: menuBoardKey,
              userId: userId,
              isAdmin: isRealAdmin,
              scrollVisible: _isVisible,
            ),
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
    _scrollControllerUp = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isVisible.dispose();
    _controller?.dispose();
    super.dispose();
  }

  // 사용자가 탭을 선택했을 때 호출되는 함수
  void _onItemTapped(int index, BuildContext context) {
    final isLoggedIn = ref.watch(loginStateProvider);
    if (_overlayEntry != null) {
      _controller?.reverse().then<void>((void value) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
    if (index != 0 && !isLoggedIn) {
      // 홈이 아닌 다른 탭을 선택하고, isToken이 false라면
      navigateToLoginScreen(context);
    } else if (index == 1) {
      _showFanMenu();
    } else {
      setState(() {
        _selectedIndex = index; // 선택된 탭의 인덱스를 업데이트
        isNoti = false;
      });
    }
  }

  void _showFanMenu() {
    print("_showFanMenu");
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _controller?.forward();
    } else {
      _controller?.reverse().then<void>((void value) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    print("createOverlayEntry");
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: <Widget>[
          // 반투명 배경
          Positioned.fill(
            bottom: 56,
            child: GestureDetector(
              onTap: () {
                // 팝업 밖의 영역을 터치하면 팝업을 닫습니다.
                _showFanMenu();
              },
              child: Container(
                color: Colors.black54.withOpacity(0.5), // 반투명 배경 색상 조절
              ),
            ),
          ),

          Positioned(
            left: (size.width - 200) / 2,
            // right: 0,
            bottom:
                56, // Adjust this value based on the height of your BottomNavigationBar
            child: Container(
              height: 100,
              width: 200,
              decoration: const BoxDecoration(
                color: Colors.white, // 색상: 파란색
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100), // 상단 왼쪽 모서리 반원
                  topRight: Radius.circular(100), // 상단 오른쪽 모서리 반원
                  // 만약 하단에 반원을 원한다면, bottomLeft와 bottomRight를 사용하세요.
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _controller!,
                      curve: Curves.easeInOut,
                    ),
                    child: _buildFanMenu(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFanMenu() {
    print('_buildFanmenu');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform.rotate(
          angle: -20 * (3.14 / 180),
          child: FloatingActionButton(
            // shape: const CircleBorder(),
            // mini: true,
            backgroundColor: Colors.white,
            foregroundColor: _selectedIndex == 1
                ? !isNoti
                    ? Colors.amber[800]
                    : Theme.of(context).primaryColor
                : Theme.of(context).primaryColor,
            elevation: 0,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.food_bank_rounded,
                  size: 40,
                ),
                Text(
                  "메뉴 건의",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                )
              ],
            ),
            onPressed: () {
              print('제안 게시판으로 이동');
              _showFanMenu();
              setState(() {
                _selectedIndex = 1;
                isNoti = false;
              });
            },
          ),
        ),
        const SizedBox(width: 20),
        Transform.rotate(
          angle: 20 * (3.14 / 180),
          child: FloatingActionButton(
            // mini: true,
            backgroundColor: Colors.white,
            foregroundColor: _selectedIndex == 1
                ? isNoti
                    ? Colors.amber[800]
                    : Theme.of(context).primaryColor
                : Theme.of(context).primaryColor,
            elevation: 0,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.announcement,
                  size: 30,
                ),
                Text(
                  "공지",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                )
              ],
            ),
            onPressed: () {
              print('공지 게시판으로 이동');
              _showFanMenu();
              setState(() {
                _selectedIndex = 1;
                isNoti = true;
              });
            },
          ),
        ),
      ],
    );
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
      _isVisible.value = true;
      return false;
    }
    return true;

    // SystemNavigator.pop();
  }

  Future<void> getServerStatus() async {
    await ApiService.getHealthy();
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
    // print("main App :: build: isAdmin $isAdmin");
    _widgetOptions = <Widget>[
      MainScreen(),
      isNoti
          ? AnnounceBoardScreen(
              isAdmin: isRealAdmin,
              scrollVisible: _isVisible,
            )
          : MenuBoardScreen(
              key: menuBoardKey,
              userId: userId,
              isAdmin: isRealAdmin,
              scrollVisible: _isVisible,
            ),
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

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: AnimatedBuilder(
            animation: _isVisible,
            builder: (context_, child) {
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
                    onPressed: () async {
                      await ApiService.postRefreshToken(accessToken!);
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
                      if (_overlayEntry != null) {
                        _controller?.reverse().then<void>((void value) {
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        });
                      }
                      // ApiService.delAutoLogin();
                      final isLoggedIn = ref.watch(loginStateProvider);
                      if (!isLoggedIn) {
                        navigateToLoginScreen(context);
                      } else {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationCenter()));

                        // if (result == true) {
                        // 필요한 상태 업데이트나 리렌더링 로직
                        setState(() {
                          getNotificationLength();
                        });
                      }
                      // }
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
          // ignore: deprecated_member_use
          body: WillPopScope(
            onWillPop: onWillPop,
            child: FutureBuilder(
                future: getServerStatus(),
                builder: (context, snapshot) {
                  // print('getServerStatus build : ${snapshot.data}');
                  if (snapshot.hasError) {
                    if (!hasError) {
                      hasError = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // 팝업 표시
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('네트워크 에러'),
                            content: const Text('원활한 인터넷 환경에서 다시 시도해주세요!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // 다이얼로그 닫기
                                  Navigator.of(context).pop();
                                  setState(() {
                                    hasError = false;
                                  });
                                },
                                child: const Text('재시도'),
                              ),
                            ],
                          ),
                        );
                      });
                    }
                  }
                  return RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      if (_selectedIndex == 1) {
                        await menuBoardKey.currentState?.loadBoardList();
                        //공지게시판도 해야하나
                      } else {
                        setState(() {
                          testValue = 2;
                        });
                      }
                    },
                    child: _selectedIndex == 1
                        ? _widgetOptions.elementAt(_selectedIndex)
                        : SingleChildScrollView(
                            controller: _scrollController,
                            child: _widgetOptions.elementAt(_selectedIndex),
                          ),
                  );
                }),
          ),
        ),
        isLoading ? buildLoadingScreenInMain() : Container(),
        // FloatingActionButton(
        //   onPressed: _scrollToTop,
        //   child: const Icon(Icons.arrow_upward),
        // )
      ],
    );
  }
}

Widget buildLoadingScreenInMain() {
  return Container(
    color: Colors.black.withOpacity(0.5), // 전체 화면을 어둡게 하여 로딩 인디케이터를 부각
    child: const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ), // 로딩 인디케이터
    ),
  );
}

Widget buildLoadingScreen() {
  return Container(
    // 전체 화면을 어둡게 하여 로딩 인디케이터를 부각
    child: const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ), // 로딩 인디케이터
    ),
  );
}
