import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tam_cafeteria_front/provider/access_token_provider.dart';

final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, bool>((ref) {
  return LoginStateNotifier(ref);
});

class LoginStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  LoginStateNotifier(this.ref) : super(false); // 초기 상태는 로그인되지 않음(false)

  void login() {
    // 로그인 로직 구현
    state = true; // 로그인 성공 시 상태를 true로 변경
  }

  void logout() {
    // 로그아웃 로직 구현
    ref.read(accessTokenProvider.notifier).clearToken();
    state = false; // 로그아웃 시 상태를 false로 변경
  }
}
