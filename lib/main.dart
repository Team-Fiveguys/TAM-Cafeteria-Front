import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool isAdmin = false;
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    const MenuBoardScreen(),
    const MyPage(),
  ];

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible == true) {
        setState(() {
          _isVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isVisible == false) {
        setState(() {
          _isVisible = true;
        });
      }
    }
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
          isAdmin ? const AdminPage() : const MyPage(),
        ];
      });
    } else {
      setState(() {
        isAdmin = false;
        _selectedIndex = isAdmin ? 2 : 0;
        _widgetOptions = <Widget>[
          MainScreen(),
          const MenuBoardScreen(),
          isAdmin ? const AdminPage() : const MyPage(),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _autoLoginCheck();
    });
    _selectedIndex = isAdmin ? 2 : 0;
    _widgetOptions = <Widget>[
      MainScreen(),
      const MenuBoardScreen(),
      isAdmin ? const AdminPage() : const MyPage(),
    ];
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('build :: ${ref.watch(loginStateProvider)}');
    final accessToken = ref.watch(accessTokenProvider);
    decodeJwt(accessToken);

    print("main App :: build: $accessToken");
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF3e3e3e),
        primaryColorLight: const Color(0xFF97948f),
        primaryColorDark: const Color(0xFF515151),
        dividerColor: const Color(0xFFc6c6c6),
        cardColor: const Color(0xFFFFDA7B),
        canvasColor: const Color(0xFF002967),
      ),
      home: Scaffold(
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: _isVisible ? 60.0 : 0.0,
          child: Wrap(
            children: [
              Builder(builder: (context) {
                return BottomNavigationBar(
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
                  currentIndex: _selectedIndex, // 현재 선택된 탭의 인덱스
                  selectedItemColor: Colors.amber[800],
                  onTap: (index) =>
                      _onItemTapped(index, context), // 탭 선택 시 호출될 함수
                );
              }),
            ],
          ),
        ),
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            leading: Opacity(
              // 투명한 아이콘 버튼 추가
              opacity: 0,
              child: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }, // 아무것도 하지 않음
                );
              }),
            ),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    // ApiService.delAutoLogin();
                    ref.read(loginStateProvider.notifier).logout();
                    print(accessToken);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NotificationCenter(), //알람 버튼
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications),
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
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
