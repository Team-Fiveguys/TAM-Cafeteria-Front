import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:tam_cafeteria_front/models/covers_model.dart';
import 'package:tam_cafeteria_front/models/diet_model.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';
import 'package:tam_cafeteria_front/models/notification_model.dart';
import 'package:tam_cafeteria_front/provider/token_interceptor.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';
// import 'package:tam_cafeteria_front/models/menu_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '', // null이면 빈 문자열로 처리
      email: json['email'] ?? '', // null이면 빈 문자열로 처리
      role: json['role'] ?? '', // null이면 빈 문자열로 처리
    );
  }
}

class ApiService {
  static const String baseUrl = "dev.tam-cafeteria.site";
  static const String aiBaseUrl = "ai.tam-cafeteria.site";
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://$baseUrl',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ))
    ..interceptors.add(TokenInterceptor());
  static Future<void> postDietPhoto(
      XFile image, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = '/diets/dietPhoto';
    final url = Uri.https(baseUrl, path);

// 파일의 MIME 타입을 결정합니다.
    String? mimeType = lookupMimeType(image.path);
    var mimeeTypeSplit =
        mimeType?.split('/') ?? ['application', 'json']; // 기본값을 제공합니다.

// 이미지 파일의 바이트 데이터를 읽습니다.
    var imageBytes = await image.readAsBytes();

// MultipartRequest 객체를 생성합니다.
    // MultipartRequest 객체를 생성합니다.
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken', // accessToken을 헤더에 추가합니다.
        'Content-Type': 'multipart/form-data',
      });
    var dietQuery = {
      'cafeteriaId': cafeteriaId.toString(),
      'meals': meals,
      'localDate': date,
    };
// 필요한 텍스트 필드를 추가합니다.
    String dietQueryJson = jsonEncode(dietQuery);

// JSON 문자열을 바이트로 변환합니다.
    List<int> dietQueryBytes = utf8.encode(dietQueryJson);

// dietQuery를 MultipartFile로 만듭니다.
    http.MultipartFile dietQueryFile = http.MultipartFile.fromBytes(
      'dietQuery', // 서버에서 기대하는 필드명을 사용해야 합니다.
      dietQueryBytes,
      contentType: MediaType('application', 'json'), // 올바른 MIME 타입 설정
    );

// 이미지 파일을 MultipartFile로 변환합니다.
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      imageBytes,
      contentType: MediaType(mimeeTypeSplit[0], mimeeTypeSplit[1]),
      filename: basename(image.path), // 파일 이름 설정
    );

// 변환된 파일을 요청에 추가합니다.
    request.files.add(multipartFile);
    request.files.add(dietQueryFile);
// 요청을 전송하고 응답을 기다립니다.
    var response = await request.send();

// 응답을 처리합니다.
    if (response.statusCode == 200) {
      print('Upload successful');
      // 응답 본문을 읽습니다.
      String responseText = await response.stream.bytesToString();
      print('Response body: $responseText');
    } else {
      print('Upload failed');
      // 실패한 경우의 응답 본문을 읽습니다.
      String responseText = await response.stream.bytesToString();
      print(
          'postDietPhoto: Response body: ${jsonDecode(responseText)['message']}');
      throw Exception(jsonDecode(responseText)['message']);
    }
  }

  static Future<void> putDietPhoto(
      XFile image, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = '/diets/dietPhoto';
    final url = Uri.https(baseUrl, path);

// 파일의 MIME 타입을 결정합니다.
    String? mimeType = lookupMimeType(image.path);
    var mimeeTypeSplit =
        mimeType?.split('/') ?? ['application', 'json']; // 기본값을 제공합니다.

// 이미지 파일의 바이트 데이터를 읽습니다.
    var imageBytes = await image.readAsBytes();

// MultipartRequest 객체를 생성합니다.
    // MultipartRequest 객체를 생성합니다.
    var request = http.MultipartRequest('PUT', url)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken', // accessToken을 헤더에 추가합니다.
        'Content-Type': 'multipart/form-data',
      });
    var dietQuery = {
      'cafeteriaId': cafeteriaId.toString(),
      'meals': meals,
      'localDate': date,
    };
// 필요한 텍스트 필드를 추가합니다.
    String dietQueryJson = jsonEncode(dietQuery);

// JSON 문자열을 바이트로 변환합니다.
    List<int> dietQueryBytes = utf8.encode(dietQueryJson);

// dietQuery를 MultipartFile로 만듭니다.
    http.MultipartFile dietQueryFile = http.MultipartFile.fromBytes(
      'dietQuery', // 서버에서 기대하는 필드명을 사용해야 합니다.
      dietQueryBytes,
      contentType: MediaType('application', 'json'), // 올바른 MIME 타입 설정
    );

// 이미지 파일을 MultipartFile로 변환합니다.
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      imageBytes,
      contentType: MediaType(mimeeTypeSplit[0], mimeeTypeSplit[1]),
      filename: basename(image.path), // 파일 이름 설정
    );

// 변환된 파일을 요청에 추가합니다.
    request.files.add(multipartFile);
    request.files.add(dietQueryFile);
// 요청을 전송하고 응답을 기다립니다.
    var response = await request.send();

// 응답을 처리합니다.
    if (response.statusCode == 200) {
      print('Upload successful');
      // 응답 본문을 읽습니다.
      String responseText = await response.stream.bytesToString();
      print('Response body: $responseText');
    } else {
      print('Upload failed');
      // 실패한 경우의 응답 본문을 읽습니다.
      String responseText = await response.stream.bytesToString();
      print(
          'putDietPhoto : Response body: ${jsonDecode(responseText)['message']}');
      throw Exception(jsonDecode(responseText)['message']);
    }
  }

  static Future<void> postMenu(String name, int cafeteriaId) async {
    const path = "/menus";

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'menuName': name,
          'cafeteriaId': cafeteriaId.toString(),
        }),
      );

      print('postMenu: ${response.data}');
    } on DioException catch (e) {
      print('postMenu: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<Diet> getMenu(int cafeteriaId) async {
    const path = "/menus";

    try {
      final response = await dio.get(
        path,
        queryParameters: {'cafeteriaId': '$cafeteriaId'},
      );

      print('getMenu: ${response.data}');

      // Parsing the response data
      final List<String> menuNames = List<String>.from(
        response.data['result']['menuQueryDTOList']
            .map((item) => item['name'] ?? ""),
      );

      final List<int> menuIds = List<int>.from(
        response.data['result']['menuQueryDTOList']
            .map((item) => item['menuId']),
      );

      final bool dayOff = response.data['result']['dayOff'] ?? false;
      final bool soldOut = response.data['result']['soldOut'] ?? false;

      return Diet(
        ids: menuIds,
        names: menuNames,
        dayOff: dayOff,
        soldOut: soldOut,
      );
    } on DioException catch (e) {
      print('getMenu: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<Diet?> getDiets(
      String date, String meals, int cafeteriaId) async {
    const path = "/diets";

    try {
      final response = await dio.get(
        path,
        queryParameters: {
          'cafeteriaId': '$cafeteriaId',
          'localDate': date,
          'meals': meals,
        },
      );

      print('getDiets: ${response.data}');

      final List<String> menuNames = List<String>.from(
        response.data['result']['menuResponseListDTO']['menuQueryDTOList']
            .map((item) => item['name']),
      );

      final List<int> menuIds = List<int>.from(
        response.data['result']['menuResponseListDTO']['menuQueryDTOList']
            .map((item) => item['menuId']),
      );

      final String? imageUrl = response.data['result']['photoURI'];
      final bool dayOff = response.data['result']['dayOff'];
      final bool soldOut = response.data['result']['soldOut'];

      return Diet(
        ids: menuIds,
        names: menuNames,
        dayOff: dayOff,
        soldOut: soldOut,
        imageUrl: imageUrl,
      );
    } on DioException catch (e) {
      print('getDiets: ${e.response?.data}');
      return null;
    }
  }

  static Future<void> postDiets(List<String> menuNameList, String date,
      String meals, int cafeteriaId, bool dayOff) async {
    const path = "/admin/diets";

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'menuNameList': menuNameList,
          'date': date,
          'meals': meals,
          'cafeteriaId': '$cafeteriaId',
          'dayOff': dayOff,
        }),
      );

      print('postDiets: ${response.data}');
    } on DioException catch (e) {
      print('postDiets: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> putDiets(
      String menuName, String date, String meals, int cafeteriaId) async {
    const path = "/admin/diets/menus";

    try {
      final response = await dio.put(
        path,
        data: jsonEncode({
          'menuName': menuName,
          'localDate': date,
          'meals': meals,
          'cafeteriaId': '$cafeteriaId',
        }),
      );

      print('putDiets: ${response.data}');
    } on DioException catch (e) {
      print('putDiets: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> deleteDiets(
      String menuName, String date, String meals, int cafeteriaId) async {
    const path = "/admin/diets/menus";

    try {
      final response = await dio.delete(
        path,
        data: jsonEncode({
          'menuName': menuName,
          'localDate': date,
          'meals': meals,
          'cafeteriaId': '$cafeteriaId',
        }),
      );

      print('deleteDiets: ${response.data}');
    } on DioException catch (e) {
      print('deleteDiets: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

//식단수정 c
  // static Future<void> updateDiets(
  //     String menuName, String date, String meals, int cafeteriaId) async {
  //   final accessToken = await TokenManagerWithSP.loadToken();
  //   final path = "/admin/diets/menus/$cafeteriaId"; // 업데이트할 메뉴의 ID를 엔드포인트에 추가
  //   final url = Uri.https(baseUrl, path);

  //   final response = await http.put(
  //     // PUT 메소드 사용
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: jsonEncode(
  //       {
  //         'menuName': menuName,
  //         'localDate': date,
  //         'meals': meals,
  //         // 'cafeteriaId': '$cafeteriaId', // PUT 메소드에서는 엔드포인트에 ID를 추가하므로 body에서 제거
  //       },
  //     ),
  //   );

  //   final String decodedResponse = utf8.decode(response.bodyBytes);

  //   // 디코드된 문자열을 JSON으로 파싱합니다.
  //   final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
  //   if (response.statusCode == 200) {
  //     print('updateDiets : $jsonResponse');
  //   } else {
  //     print('updateDiets : $jsonResponse');
  //   }
  // }

  static Future<void> postRefreshToken(String? accessToken) async {
    const path = '/token/access-token';
    print("api_service : postRefresh");
    if (accessToken == null) {
      throw Exception();
    }
    // 새로운 Dio 인스턴스 생성 (Interceptor를 추가하지 않음)
    Dio dioWithoutInterceptor = Dio(BaseOptions(
      baseUrl: 'https://$baseUrl',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    try {
      final response = await dioWithoutInterceptor.post(
        path,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print("------------------$response");
      if (response.statusCode != 200) {
        throw Exception();
      }

      print(
          'ApiService:postRefreshToken :: ${response.headers.value('accessToken')}');
      if (response.headers.value('accessToken') == null)
        throw Exception(response.data['message']);
      await TokenManagerWithSP.saveToken(
          response.headers.value('accessToken')!);
    } on DioException catch (e) {
      print('postRefreshToken: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<String?> postKakaoLogin(
      String idToken, String accessToken) async {
    const path = '/oauth2/kakao/token/validate';

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'identityToken': idToken,
          'accessToken': accessToken,
        }),
      );

      print(
          'ApiService:postKakaoLogin :: ${response.data['result']['accessToken']}');
      return response.data['result']['accessToken'];
    } on DioException catch (e) {
      print('postKakaoLogin: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<String> postEmailAuthCode(String email) async {
    const path = '/auth/email';

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({'email': email}),
      );

      return 'true';
    } on DioException catch (e) {
      print('postEmailAuthCode: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<bool> postEmailVerification(
      String email, String authCode) async {
    const path = '/auth/email/verification';

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'email': email,
          'authCode': authCode,
        }),
      );

      return true;
    } on DioException catch (e) {
      print('postEmailVerification: ${e.response?.data}');
      return false;
    }
  }

  static Future<bool> postSignUp(
      String name, String password, String email, String authcode) async {
    const path = "/sign-up";

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'name': name,
          'password': password,
          'email': email,
          'authCode': authcode,
        }),
      );

      return true;
    } on DioException catch (e) {
      print('postSignUp: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<String?> postSignIn(String email, String password) async {
    const path = "/auth/email/sign-in";

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print(
          'ApiService:postSignIn :: ${response.data['result']['accessToken']}');
      return response.data['result']['accessToken'];
    } on DioException catch (e) {
      print('postSignIn: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> postCongestionStatus(
      String? congestion, int cafeteriaId) async {
    final path = "/admin/cafeterias/$cafeteriaId/congestion";

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'congestion': congestion,
        }),
      );

      print('ApiService : postCongestionStatus : ${response.data}');
    } on DioException catch (e) {
      print('postCongestionStatus: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<String> getCongestionStatus(int cafeteriaId) async {
    final path = "/cafeterias/$cafeteriaId/congestion";

    try {
      final response = await dio.get(path);

      if (response.data['result']['congestion'] != null) {
        return response.data['result']['congestion'];
      } else {
        return "운영안함";
      }
    } on DioException catch (e) {
      print('getCongestionStatus: ${e.response?.data}');
      return "운영안함";
    }
  }

  //

  static Future<String?> postAppleLogin(
      String? socialId, String? identityToken, String authorizationCode) async {
    const path = '/oauth2/apple/token/validate';

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          'socialId': socialId,
          'identityToken': identityToken,
          'authorizationCode': authorizationCode,
        }),
      );

      print(
          'ApiService:postAppleLogin :: ${response.data['result']['accessToken']}');
      return response.data['result']['accessToken'];
    } on DioException catch (e) {
      print('postAppleLogin: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> patchDayOffStatus(
      int cafeteriaId, String date, String meals) async {
    const path = "/admin/diets/dayOff";

    try {
      final response = await dio.patch(
        path,
        data: jsonEncode({
          'cafeteriaId': cafeteriaId.toString(),
          'localDate': date,
          'meals': meals,
        }),
      );

      print(
          'ApiService : patchDayOffStatus ${response.data['result']['dayOff']}');
    } on DioException catch (e) {
      print('patchDayOffStatus: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<bool> patchSoldOutStatus(
      int cafeteriaId, String date, String meals) async {
    const path = "/admin/diets/sold-out";

    try {
      final response = await dio.patch(
        path,
        data: jsonEncode({
          'cafeteriaId': cafeteriaId.toString(),
          'localDate': date,
          'meals': meals,
        }),
      );

      print(
          'ApiService : patchSoldOutStatus ${response.data['result']['soldOut']}');
      return response.data['result']['soldOut'];
    } on DioException catch (e) {
      print('patchSoldOutStatus: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<Map<String?, Diet>> getDietsInMain(int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/diets/main";

    final Map<String, dynamic> queryParameters = {
      'cafeteriaId': cafeteriaId,
    };

    try {
      final response = await dio.get(path,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));

      if (response.statusCode == 200) {
        Map<String?, Diet> responseData = {};
        final instance = response.data['result'];
        for (var resultInstance in instance) {
          final date = resultInstance['date'];
          final List<String> menuNames = List<String>.from(
            resultInstance['menuResponseListDTO']['menuQueryDTOList']
                .map((item) => item['name'] as String),
          );
          final List<int> menuIds = List<int>.from(
            resultInstance['menuResponseListDTO']['menuQueryDTOList']
                .map((item) => item['menuId'] as int),
          );
          final dayOff = resultInstance['dayOff'];
          final soldOut = resultInstance['soldOut'];
          final meals = resultInstance['meals'];
          Diet diet = Diet(
            names: menuNames,
            ids: menuIds,
            dayOff: dayOff,
            soldOut: soldOut,
            meals: meals,
          );
          responseData[date] = diet;
        }
        return responseData;
        // return response.data['result']['threeWeeksDietsResponseDTOS'];
      } else {
        // 에러 처리
        print("Request failed with status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print("Request to $path timed out.");
      } else {
        print("Request to $path failed: ${e.message}");
      }
    } catch (e) {
      // 기타 예외 발생 시 처리 로직
      print("Request to $path failed: $e");
    }

    return {};
  }

  static Future<void> postNotificationToSubscriber(String title, String content,
      String cafeteriaName, String notificationType) async {
    const path = "/admin/notifications/topic/subscriber";

    try {
      final response = await dio.post(path,
          data: jsonEncode({
            "title": title,
            "content": content,
            "cafeteriaName": cafeteriaName,
            "notificationType": notificationType,
          }));

      print('ApiService : postNotificationToSubscriber : ${response.data}');
    } on DioException catch (e) {
      print('postNotificationToSubscriber: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> postNotificationSet(String registrationToken) async {
    const path = "/users/notificationSet";

    try {
      final response = await dio.post(
        path,
        queryParameters: {
          "registrationToken": registrationToken,
        },
      );

      print('ApiService : postNotificationSet : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : postNotificationSet : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> putRegistrationToken(String registrationToken) async {
    const path = "/users/notificationSet/registration-token";

    try {
      final response = await dio.put(
        path,
        queryParameters: {
          "registrationToken": registrationToken,
        },
      );

      print(
          'ApiService : putRegistrationToken : $registrationToken, ${response.data}');
    } on DioException catch (e) {
      print('ApiService : putRegistrationToken : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<String?> getRegistrationToken() async {
    const path = "/users/notificationSet/registration-token";

    try {
      final response = await dio.get(path);

      return response.data['result']['registrationToken'];
    } on DioException catch (e) {
      print('ApiService : getRegistrationToken : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> postNotificationToAllUser(
      String title, String content) async {
    const path = "/admin/notifications/users";

    try {
      final response = await dio.post(
        path,
        data: jsonEncode({
          "title": title,
          "content": content,
        }),
      );

      print('ApiService : postNotificationToAllUser : ${response.data}');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<List<NotificationModel>> getNotifications() async {
    const path = "/users/notifications";

    try {
      final response = await dio.get(path);

      List<dynamic> resultList = response.data['result']['notificationList'];
      List<NotificationModel> notificationList = [];
      for (var notification in resultList) {
        NotificationModel instance = NotificationModel(
          id: notification['id'],
          title: notification['title'],
          content: notification['content'],
          date: notification['transmitTime'],
          isRead: notification['read'],
        );
        notificationList.add(instance);
      }
      return notificationList;
    } on DioException catch (e) {
      print('ApiService : getNotifications : ${e.response?.data}');
      return [];
    }
  }

  static Future<void> postNotificationToServer(String notificationId) async {
    final path = "/users/notifications/$notificationId";

    try {
      final response = await dio.post(path);

      print('ApiService : postNotificationToServer : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : postNotificationToServer : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> deleteOneNotification(String notificationId) async {
    final path = "/users/notifications/$notificationId";

    try {
      final response = await dio.delete(path);

      print('ApiService : deleteOneNotification : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : deleteOneNotification : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> deleteAllNotification() async {
    const path = "/users/notifications";

    try {
      final response = await dio.delete(path);
      print('ApiService : deleteAllNotification : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : deleteAllNotification : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> readOneNotification(String notificationId) async {
    final path = "/users/notifications/$notificationId/read";

    try {
      final response = await dio.patch(path);
      print('ApiService : readOneNotification : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : readOneNotification : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<List<User>> getUsers(int page) async {
    const path = '/admin';

    try {
      final response = await dio.get(path, queryParameters: {'page': page});
      final Map<String, dynamic> data = response.data;
      List<User> users = List<User>.from(
          data["result"]["userList"].map((x) => User.fromJson(x)));
      return users;
    } on DioException catch (e) {
      print(
          'API Service: getUsers: Error with status code: ${e.response?.statusCode}');
      throw Exception('Failed to load users');
    }
  }

  static Future<void> revokeAdminRole(int userId) async {
    final path = '/admin/users/$userId/role/user';

    try {
      final response = await dio.patch(path);
      print('관리자 권한 회수 성공: ${response.data}');
    } on DioException catch (e) {
      print('관리자 권한 회수 실패: ${e.response?.statusCode}');
      throw Exception('Failed to revoke admin role');
    }
  }

  static Future<bool> grantAdminRole(int userId) async {
    final path = '/admin/users/$userId/role/admin';

    try {
      final response = await dio.patch(path);
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.data['isSuccess'] == true) {
        return true;
      } else {
        print('Failed to grant admin role. Response: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print(
          'Failed to grant admin role. Status code: ${e.response?.statusCode}');
      throw Exception('Failed to grant admin role');
    }
  }

  static Future<void> readAllNotification() async {
    const path = "/users/notifications/read";

    try {
      final response = await dio.patch(path);
      print('ApiService : readAllNotification : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : readAllNotification : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> postAddCafeteria(
      String name,
      String location,
      bool runBreakfast,
      bool runLunch,
      String? breakfastTime,
      String? lunchTime) async {
    const path = "/admin/cafeterias";

    String breakfastStart =
        runBreakfast ? "${breakfastTime!.split('~')[0]}:00" : "";
    String breakfastEnd =
        runBreakfast ? "${breakfastTime!.split('~')[1]}:00" : "";
    String lunchStart = runLunch ? "${lunchTime!.split('~')[0]}:00" : "";
    String lunchEnd = runLunch ? "${lunchTime!.split('~')[1]}:00" : "";

    try {
      final response = await dio.post(
        path,
        data: {
          "name": name,
          "location": location,
          'runBreakfast': runBreakfast,
          'runLunch': runLunch,
          "breakfastStartTime": breakfastStart,
          "breakfastEndTime": breakfastEnd,
          "lunchStartTime": lunchStart,
          "lunchEndTime": lunchEnd,
        },
      );
      print('ApiService : postAddCafeteria : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : postAddCafeteria : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<List<Cafeteria>> getCafeteriaList() async {
    const path = '/admin/me/cafeterias';

    try {
      final response = await dio.get(path);
      final List<dynamic> data = response.data['result']['queryCafeteriaList'];
      return data.map((item) => Cafeteria.fromJson(item)).toList();
    } on DioException catch (e) {
      print('Error fetching cafeteria list: ${e.message}');
      throw Exception('Failed to fetch cafeteria list');
    }
  }

//알람 api
  static Future<Map<String, bool>> getNotificationSettings() async {
    const path = "/users/notificationSet";

    try {
      final response = await dio.get(path);
      final Map<String, dynamic> jsonResponse = response.data;

      if (jsonResponse['result'] != null && jsonResponse['result'] is Map) {
        final Map<String, dynamic> resultMap = jsonResponse['result'];
        final Map<String, bool> result = {};
        resultMap.forEach((key, value) {
          if (value is bool) {
            result[key] = value;
          } else {
            print("Warning: The value for '$key' is not a bool.");
          }
        });
        return result;
      }
      return {};
    } on DioException catch (e) {
      print('getNotificationSettings: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> updateNotificationSettings(
      Map<String, bool> newSettings) async {
    const path = "/users/notificationSet";

    try {
      final response = await dio.put(path, data: newSettings);
      print('updateNotificationSettings: ${response.data}');
    } on DioException catch (e) {
      print('updateNotificationSettings: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<dynamic> getUserInfo() async {
    const path = "/users/me";

    try {
      final response = await dio.get(path);
      return response.data['result'];
    } on DioException catch (e) {
      print('getUserInfo: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> deleteUser() async {
    const path = "/users/me";

    try {
      final response = await dio.delete(path);
      print('deleteUser: ${response.data}');
    } on DioException catch (e) {
      print('deleteUser: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> deleteLogOut() async {
    const path = "/logout";

    try {
      final response = await dio.delete(path);
      print('logout: ${response.data}');
    } on DioException catch (e) {
      print('logout: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> fetchMenuBoardList(
    int cafeteriaId,
    int page,
    String orderType,
  ) async {
    const path = "/posts/menu-request";

    try {
      final response = await dio.get(path, queryParameters: {
        'cafeteriaId': '$cafeteriaId',
        'page': '$page',
        'orderType': orderType,
      });

      if (response.statusCode == 200) {
        final List<dynamic> resultList =
            response.data['result']['postPreviewDTOList'];
        final int lastPage = response.data['result']['totalPages'];
        final List<Map<String, dynamic>> boardList = resultList.map((item) {
          return {
            'id': item['id'],
            'title': item['title'],
            'content': item['content'],
            'publisherName': item['publisherName'],
            'uploadTime': item['uploadTime'],
            'likeCount': item['likeCount'],
            'totalPages': lastPage,
          };
        }).toList();
        return boardList;
      } else {
        print('상태 코드: ${response.statusCode}로 요청이 실패했습니다.');
        return [];
      }
    } on DioException catch (e) {
      print('오류 발생: ${e.message}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchNoticeBoardList(
    int cafeteriaId,
    int page,
  ) async {
    const path = "/posts/notice";

    try {
      final response = await dio.get(path, queryParameters: {
        'cafeteriaId': '$cafeteriaId',
        'page': '$page',
      });

      if (response.statusCode == 200) {
        final List<dynamic> resultList =
            response.data['result']['postPreviewDTOList'];
        final int lastPage = response.data['result']['totalPages'];
        final List<Map<String, dynamic>> boardList = resultList.map((item) {
          return {
            'id': item['id'],
            'title': item['title'],
            'content': item['content'],
            'publisherName': item['publisherName'],
            'uploadTime': item['uploadTime'],
            'likeCount': item['likeCount'],
            'totalPages': lastPage,
          };
        }).toList();
        return boardList;
      } else {
        print('상태 코드: ${response.statusCode}로 요청이 실패했습니다.');
        return [];
      }
    } on DioException catch (e) {
      print('오류 발생: ${e.message}');
      return [];
    }
  }

  static Future<void> createPost(
      String boardType, String title, String content, int cafeteriaId) async {
    const path = "/posts";

    try {
      final response = await dio.post(
        path,
        data: {
          "boardType": boardType,
          "title": title,
          "content": content,
          "cafeteriaId": cafeteriaId,
        },
      );
      print('ApiService : createPost : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : createPost : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> togglePostLike(int postId) async {
    final path = "/posts/$postId/like";

    try {
      final response = await dio.post(path);
      print('ApiService : togglePostLike : ${response.data}');
    } on DioException catch (e) {
      print('ApiService : togglePostLike : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<Map<String, dynamic>> fetchBoardDetail(int id) async {
    final path = "/posts/$id";

    try {
      final response = await dio.get(path);
      return response.data['result'];
    } on DioException catch (e) {
      print('상태 코드: ${e.response?.statusCode}로 요청이 실패했습니다.');
      return {};
    }
  }

  static Future<void> deletePost(int postId) async {
    final path = "/posts/$postId";

    try {
      final response = await dio.delete(path);
      print('deletePost : ${response.data}');
    } on DioException catch (e) {
      print('Error in deletePost : ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> updatePost(
      int postId, String newTitle, String newContent) async {
    final path = "/posts/$postId";

    try {
      final response = await dio.put(
        path,
        data: {
          'title': newTitle,
          'content': newContent,
        },
      );
      print('게시글이 성공적으로 수정되었습니다: ${response.data}');
    } on DioException catch (e) {
      print('상태 코드: ${e.response?.statusCode}로 요청이 실패했습니다.');
      throw Exception(e.response?.data['message']);
    }
  }

  static Future<void> reportPost(int postId) async {
    final path = "/posts/$postId/report";

    try {
      final response = await dio.post(path, data: {'id': postId});
      print('ApiService: reportPost: ${response.data}');
    } on DioException catch (e) {
      print('ApiService: reportPost: ${e.response?.data}');
      throw Exception(e.response?.data['message']);
    }
  }

  //============AI API============
  //============AI API============
  //============AI API============
  //============AI API============

  static Future<String?> getSemesterStartDateAI() async {
    // final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/start_date";
    final url = Uri.https(aiBaseUrl, path);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : getSemesterStartDateAI : $jsonResponse');
      return jsonResponse['start_date'];
    } else {
      // throw Exception(jsonResponse['message']);
    }
    return null;
  }

  static Future<String?> postPredict1CoversAI(
      String startDate,
      String date,
      int cafeteriaId,
      bool festival,
      bool snack,
      bool reservist,
      bool spicy) async {
    // final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/predict1";
    final url = Uri.https(aiBaseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'start_date': startDate,
        'local_date': date,
        'cafeteria_id': cafeteriaId,
        'festival': festival,
        'snack': snack,
        'reservist': reservist,
        'spicy': spicy,
      }),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postPredictCoversAI : $jsonResponse');
      return jsonResponse['predict_result'].toString();
    } else {}
    throw Exception('예측 실패');
  }

  static Future<String?> postPredict2CoversAI(
    String startDate,
    String date,
    int cafeteriaId,
  ) async {
    // final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/predict2";
    final url = Uri.https(aiBaseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'start_date': startDate,
        'local_date': date,
        'cafeteria_id': cafeteriaId,
      }),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postPredict2CoversAI : $jsonResponse');
      return jsonResponse['predict_result'].toString();
    } else {}
    throw Exception('예측 실패');
  }

  static Future<void> postSemesterStartDate(String startDate) async {
    const path = "/add_semester";
    final url = Uri.https(aiBaseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'start_date': startDate,
      }),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postSemesterStartDate : $jsonResponse');
    } else {}
    // throw Exception('예측 실패');
  }

  static Future<void> postRealCovers(
      String date, int cafeteriaId, String headCount) async {
    const path = "/headcount";
    final url = Uri.https(aiBaseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'local_date': date,
        'cafeteria_id': cafeteriaId,
        'headcount': headCount,
      }),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postRealCovers : $jsonResponse');
    } else {}
    // throw Exception('예측 실패');
  }

  static Future<String?> getRealCovers(String date, int cafeteriaId) async {
    const path = "/headcount";
    final url = Uri.https(aiBaseUrl, path, {
      'local_date': date,
      'cafeteria_id': cafeteriaId.toString(),
    });

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : getRealCovers : $jsonResponse');
      return jsonResponse['headcount'].toString();
    } else {}
    return null;
  }

  static Future<Covers?> getCoversResult(String date, int cafeteriaId) async {
    const path = "/predict";
    final url = Uri.https(aiBaseUrl, path, {
      'local_date': date,
      'cafeteria_id': cafeteriaId.toString(),
    });

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);
    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : getCoversResult : $jsonResponse');
      final instance = jsonDecode(jsonResponse['data']);
      Covers result = Covers(
        isSnack: instance['snack'] ?? false,
        isFestival: instance['festival'] ?? false,
        isReservist: instance['reservist'] ?? false,
        isSpicy: instance['spicy'] ?? false,
        predictResult: jsonResponse['predict_result'],
      );
      return result;
    } else {}
    return null;
  }

  static Future<void> getHealthy() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/health";
    final url = Uri.https(baseUrl, path);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    // final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    print('getHealthy : $decodedResponse');
    if (response.statusCode == 200) {
    } else {
      // print('getHealthy : $jsonResponse');
      // return jsonResponse['message'];
      throw Exception();
    }
  }
}
