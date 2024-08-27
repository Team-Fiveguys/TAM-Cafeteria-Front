import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';

final accessTokenProvider =
    StateNotifierProvider<AccessTokenNotifier, String?>((ref) {
  // final accessToken = TokenManagerWithSP.loadToken();

  // 여기서는 초기 토큰 값이 없으므로 null을 전달하거나, `SharedPreferences`에서 값을 로드하는 로직을 포함시켜야 합니다.
  return AccessTokenNotifier(null); // 초기 토큰 값으로 null을 사용합니다.
});

class AccessTokenNotifier extends StateNotifier<String?> {
  AccessTokenNotifier(String? initialToken) : super(initialToken);

  void setToken(String? token) async {
    state = token;
    if (token == null) {
      await TokenManagerWithSP.removeToken();
    } else {
      // await TokenManagerWithSP.removeToken();
      await TokenManagerWithSP.saveToken(token);
    }
  }

  void clearToken() async {
    state = null;
    await TokenManagerWithSP.removeToken();
  }
}
