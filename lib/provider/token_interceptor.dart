import 'package:dio/dio.dart';
import 'package:tam_cafeteria_front/main.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';
import 'package:tam_cafeteria_front/services/api_service.dart';

// TokenInterceptor 예시 (이미 구현한 것)
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 토큰 유효성 확인 후 만료 시 갱신
    String? token = await TokenManagerWithSP.loadToken(); // accessToken 가져오기

    if (token != null && TokenManagerWithSP.isExpiredToken(token)) {
      try {
        print("onRequest");
        await ApiService.postRefreshToken(token);
      } on Exception {
        await TokenManagerWithSP.removeToken();
        navigatorKey.currentState
            ?.pushReplacementNamed('/login'); // 로그인 화면으로 이동
        return;
      }
// 만료 시 토큰 갱신
      token = await TokenManagerWithSP.loadToken(); // 갱신된 토큰 가져오기
    }

    // Authorization 헤더에 토큰 추가
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 필요한 경우 오류 처리 (예: 401 오류 처리 후 토큰 재발급 시도 등)
    if (err.response?.statusCode == 401) {
      // 401 오류 발생 시 로그인 화면으로 이동
      navigatorKey.currentState?.pushReplacementNamed('/login');
    }
    super.onError(err, handler);
  }
}
