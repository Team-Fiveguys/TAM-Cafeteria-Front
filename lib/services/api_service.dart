import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:tam_cafeteria_front/models/diet_model.dart';
import 'package:tam_cafeteria_front/models/notification_model.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';

class ApiService {
  static const String baseUrl = "dev.tam-cafeteria.site";

  static Future<void> postDietPhoto(
      XFile image, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = '/diets/dietPhoto';
    final url = Uri.http(baseUrl, path);

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
      print('Response body: $responseText');
    }
  }

  static Future<void> postMenu(String name, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/menus";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken' // JSON 형식의 데이터를 전송한다고 명시합니다.
        },
        body: jsonEncode(
          {
            'name': name,
            'cafeteriaId': cafeteriaId.toString(),
          },
        ));
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('postMenu : $jsonResponse');
    } else {
      print('postMenu : $jsonResponse');
    }
  }

  static Future<Diet> getMenu(int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/menus";
    final url = Uri.http(baseUrl, path, {'cafeteriaId': '$cafeteriaId'});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      // UTF-8 인코딩을 사용하여 응답 본문을 디코드합니다.
      final String decodedResponse = utf8.decode(response.bodyBytes);

      // 디코드된 문자열을 JSON으로 파싱합니다.
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

      // 'result' 키에 해당하는 부분을 추출하고, 'menuQueryDTOList' 내부를 순회하며 각 항목의 'name'을 추출하여 리스트를 생성합니다.
      final List<String> menuNames = List<String>.from(
        jsonResponse['result']['menuQueryDTOList']
            .map((item) => item['name'] as String),
      );

      final List<int> menuIds = List<int>.from(
        jsonResponse['result']['menuQueryDTOList']
            .map((item) => item['menuId'] as int),
      );

      final bool dayOff = jsonResponse['result']['dayOff'] ?? false;
      final bool soldOut = jsonResponse['result']['soldOut'] ?? false;

      return Diet(
          ids: menuIds, names: menuNames, dayOff: dayOff, soldOut: soldOut);
    }
    throw Error();
  }

  static Future<Diet?> getDiets(
      String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();

    const path = "/diets";
    final url = Uri.http(
      baseUrl,
      path,
      {
        'cafeteriaId': '$cafeteriaId',
        'localDate': date,
        'meals': meals,
      },
    );

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    });
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // UTF-8 인코딩을 사용하여 응답 본문을 디코드합니다.
      // print("ApiService : getDiets: response : $date $jsonResponse");
      // 'result' 키에 해당하는 부분을 추출하고, 'menuQueryDTOList' 내부를 순회하며 각 항목의 'name'을 추출하여 리스트를 생성합니다.
      final List<String> menuNames = List<String>.from(
        jsonResponse['result']['menuResponseListDTO']['menuQueryDTOList']
            .map((item) => item['name'] as String),
      );

      final List<int> menuIds = List<int>.from(
        jsonResponse['result']['menuResponseListDTO']['menuQueryDTOList']
            .map((item) => item['menuId'] as int),
      );

      final String? imageUrl = jsonResponse['result']['photoURI'];

      final bool dayOff = jsonResponse['result']['dayOff'];
      final bool soldOut = jsonResponse['result']['soldOut'];

      return Diet(
        ids: menuIds,
        names: menuNames,
        dayOff: dayOff,
        soldOut: soldOut,
        imageUrl: imageUrl,
      );
    }
    // print("ApiService : getDiets: response : $date $jsonResponse");
    // throw Error();
    return null;
  }

  static Future<void> postDiets(List<String> menuNameList, String date,
      String meals, int cafeteriaId, bool dayOff) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            'menuNameList': menuNameList,
            'date': date,
            'meals': meals,
            'cafeteriaId': '$cafeteriaId',
            'dayOff': dayOff,
          },
        ));
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('postDiets : $jsonResponse');
    } else {
      print('postDiets : $jsonResponse');
    }
  }

  static Future<void> putDiets(
      String menuName, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/menus";
    final url = Uri.http(baseUrl, path);

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            'menuName': menuName,
            'localDate': date,
            'meals': meals,
            'cafeteriaId': '$cafeteriaId',
          },
        ));
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('putDiets : $jsonResponse');
    } else {
      print('putDiets : $jsonResponse');
    }
  }

  static Future<void> deleteDiets(
      String menuName, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/menus";
    final url = Uri.http(baseUrl, path);

    final response = await http.delete(url,
        headers: {
          'Content-Type': 'application/json',
          // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            'menuName': menuName,
            'localDate': date,
            'meals': meals,
            'cafeteriaId': '$cafeteriaId',
          },
        ));
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('putDiets : $jsonResponse');
    } else {
      print('putDiets : $jsonResponse');
    }
  }

  static Future<String?> postKakaoLogin(
      String idToken, String accessToken) async {
    const path = '/oauth2/kakao/token/validate';
    final url = Uri.http(baseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식의 데이터를 전송한다고 명시합니다.
      },
      body: jsonEncode(
        {
          'identityToken': idToken,
          'accessToken': accessToken,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print(
          'ApiService:postKakaoLogin :: ${jsonResponse['result']['accessToken']}');

      return jsonResponse['result']['accessToken'];
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
    throw Error();
  }

  static Future<String> postEmailAuthCode(String email) async {
    const path = '/auth/email';
    final url = Uri.http(baseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식의 데이터를 전송한다고 명시합니다.
      },
      body: jsonEncode(
        {
          'email': email,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print(jsonResponse);

      return 'true';
    } else {
      print(jsonResponse);
      return jsonResponse['message'];
    }
  }

  static Future<bool> postEmailVerification(
      String email, String authCode) async {
    const path = '/auth/email/verification';
    final url = Uri.http(baseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식의 데이터를 전송한다고 명시합니다.
      },
      body: jsonEncode(
        {
          'email': email,
          'authCode': authCode,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print(jsonResponse);
      return true;
    } else {
      print(jsonResponse);
      return false;
    }
  }

  static Future<bool> postSignUp(String name, String password, String sex,
      String email, String authcode) async {
    const path = "/sign-up";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
        },
        body: jsonEncode(
          {
            'name': name,
            'password': password,
            'sex': sex,
            'email': email,
            'authCode': authcode,
          },
        ));

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.body);
    }
    throw Error();
  }

  static Future<String?> postSignIn(String email, String password) async {
    const path = "/auth/email/sign-in";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ));

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print(
          'ApiService:postKakaoLogin :: ${jsonResponse['result']['accessToken']}');

      return jsonResponse['result']['accessToken'];
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
    throw Error();
  }

  static Future<void> postCongestionStatus(
      String congestion, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/admin/cafeterias/$cafeteriaId/congestion";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            'congestion': congestion,
          },
        ));

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postCongestionStatus : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<String> getCongestionStatus(int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/cafeterias/$cafeteriaId/congestion";
    final url = Uri.http(baseUrl, path);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // print('ApiService : getCongestionStatus : $jsonResponse');
      if (jsonResponse['result']['congestion'] != null) {
        return jsonResponse['result']['congestion'];
      }
    } else {
      print(jsonResponse);
    }
    return "선택 안함";
  }

  static Future<String?> postAppleLogin(
      String? socialId, String? identityToken, String authorizationCode) async {
    const path = '/oauth2/apple/token/validate';
    final url = Uri.http(baseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식의 데이터를 전송한다고 명시합니다.
      },
      body: jsonEncode(
        {
          'socialId': socialId,
          'identityToken': identityToken,
          'authorizationCode': authorizationCode,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print(
          'ApiService:postAppleLogin :: ${jsonResponse['result']['accessToken']}');

      return jsonResponse['result']['accessToken'];
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
    throw Error();
  }

  static Future<void> patchDayOffStatus(int cafeteriaId, String date) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/dayOff";
    final url = Uri.http(baseUrl, path);

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(
        {
          'cafeteriaId': cafeteriaId.toString(),
          'localDate': date,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // print('ApiService : getCongestionStatus : $jsonResponse');
      print('${jsonResponse['result']['dayOff']}');
    } else {
      print(jsonResponse);
    }
  }

  static Future<Map<String?, Diet>> getWeekDiets(
      int cafeteriaId, int year, int month, int weekNum, String meals) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/diets/weeks";
    final Map<String, dynamic> queryParameters = {
      'cafeteriaId': cafeteriaId.toString(),
      'year': year.toString(),
      'month': month.toString(),
      'weekNum': weekNum.toString(),
      'meals': meals,
    };

    // Uri 생성 시 queryParameters를 전달합니다.
    final url = Uri.http(baseUrl, path, queryParameters);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // print('ApiService : getCongestionStatus : $jsonResponse');
      Map<String?, Diet> responseData = {};
      final instance = jsonResponse['result']['dietResponseDTOList'];
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
        Diet diet = Diet(
            names: menuNames, ids: menuIds, dayOff: dayOff, soldOut: soldOut);
        responseData[date] = diet;
      }
      return responseData;
    } else {
      print(jsonResponse);
    }
    return {};
  }

  static Future<void> postNotificationToSubscriber(String title, String content,
      String cafeteriaName, String notificationType) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/notifications/topic/subscriber";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            "title": title,
            "content": content,
            "cafeteriaName": cafeteriaName,
            "notificationType": notificationType,
          },
        ));

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postNotificationToSubscriber : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<void> postNotificationSet(String registrationToken) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notificationSet";
    final url = Uri.http(
      baseUrl,
      path,
      {
        "registrationToken": registrationToken,
      },
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postNotificationSet : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<void> postNotificationToAllUser(
      String title, String content) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/notifications/general/users";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            "title": title,
            "content": content,
          },
        ));

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postNotificationToAllUser : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<List<NotificationModel>> getNotifications() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notifications";
    final url = Uri.http(baseUrl, path);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : getNotifications : $jsonResponse');
      List<dynamic> resultList = jsonResponse['result']['notificationList'];
      List<NotificationModel> notificationList = [];
      for (var notification in resultList) {
        NotificationModel instance = NotificationModel(
          id: notification['id'],
          title: notification['title'],
          content: notification['content'],
          date: notification['transmitDate'],
          isRead: notification['read'],
        );
        notificationList.add(instance);
      }
      return notificationList;
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
    return [];
  }

  static Future<void> postNotificationToServer(String notificationId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/users/notifications/$notificationId";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postNotificationToServer : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<void> deleteOneNotification(String notificationId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/users/notifications/$notificationId";
    final url = Uri.http(baseUrl, path);

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postNotificationToServer : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<void> deleteAllNotification() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notifications";
    final url = Uri.http(baseUrl, path);

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : deleteAllNotification : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }

  static Future<void> readOneNotification(String notificationId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/users/notifications/$notificationId/read";
    final url = Uri.http(baseUrl, path);

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : deleteAllNotification : $jsonResponse');
    } else {
      print(jsonResponse);
      // return jsonResponse['message'];
    }
  }
}
