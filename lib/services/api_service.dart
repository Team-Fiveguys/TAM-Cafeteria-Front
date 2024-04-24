import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tam_cafeteria_front/models/diets_model.dart';
import 'package:tam_cafeteria_front/models/menu_model.dart';
import 'package:tam_cafeteria_front/models/result_model.dart';
import 'package:tam_cafeteria_front/provider/access_token_provider.dart';
import 'package:tam_cafeteria_front/provider/token_manager.dart';

class ApiService {
  static const String baseUrl = "dev.tam-cafeteria.site";

  static Future<void> test() async {
    // final url = Uri.http('dev.tam-cafeteria.site', '/cafeteria', {
    //   'name': "명진당",
    //   'address': "123",
    //   'hour': "11:30 ~ 14:30",
    // });
    const path = "/diets/1/MONDAY";
    final url = Uri.http(
      baseUrl,
      path,
      {'meals': "BREAKFAST"},
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final instance = Result.fromJson(jsonDecode(response.body));
      // final dietsInstance = Diets.fromJson(instance.result);
      // final menuInstance = Menu.fromJson(dietsInstance.menu);
      // print('dietsInstance : ${menuInstance.menuList}');
    } else {
      log("message");
    }
  }

  static Future<void> postDietPhoto(XFile image) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const dietId = 4;
    final url = Uri.http(baseUrl, "/diets/$dietId/dietPhoto");

// 파일의 MIME 타입을 결정합니다.
    String? mimeType = lookupMimeType(image.path);
    var mimeeTypeSplit =
        mimeType?.split('/') ?? ['application', 'octet-stream']; // 기본값을 제공합니다.

// 이미지 파일의 바이트 데이터를 읽습니다.
    var imageBytes = await image.readAsBytes();

// MultipartRequest 객체를 생성합니다.
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer $accessToken', // accessToken을 헤더에 추가합니다.
        'Content-Type': 'multipart/form-data',
      });

// 이미지 파일을 MultipartFile로 변환합니다.
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      imageBytes,
      contentType: MediaType(mimeeTypeSplit[0], mimeeTypeSplit[1]),
      filename: basename(image.path), // 파일 이름 설정
    );

// 변환된 파일을 요청에 추가합니다.
    request.files.add(multipartFile);

// 요청을 전송하고 응답을 기다립니다.
    var response = await request.send();

// 응답을 처리합니다.
    if (response.statusCode == 200) {
      print('Upload successful');
      String responseText = await response.stream.bytesToString();
      print('Response body: $responseText');
    } else {
      print('Upload failed');
      String responseText = await response.stream.bytesToString();
      print('Response body: $responseText');
    }
  }

  static Future<void> postMenu(String name) async {
    const int cafeteriaId = 1;
    const path = "/menus";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json', // JSON 형식의 데이터를 전송한다고 명시합니다.
        },
        body: jsonEncode(
          {
            'name': name,
            'cafeteriaId': cafeteriaId,
          },
        ));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  static Future<Menu> getMenu() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const int cafeterialId = 1;
    const path = "/menus";
    final url = Uri.http(baseUrl, path, {'cafeteriaId': '$cafeterialId'});

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

      return Menu(ids: menuIds, names: menuNames);
    }
    throw Error();
  }

  static Future<Menu?> getDiets(String date, String meals) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const int cafeterialId = 1;
    const path = "/diets";
    final url = Uri.http(
      baseUrl,
      path,
      {
        'cafeteriaId': '$cafeterialId',
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
      print("ApiService : getDiets: response : $date $jsonResponse");
      // 'result' 키에 해당하는 부분을 추출하고, 'menuQueryDTOList' 내부를 순회하며 각 항목의 'name'을 추출하여 리스트를 생성합니다.
      final List<String> menuNames = List<String>.from(
        jsonResponse['result']['menuResponseListDTO']['menuQueryDTOList']
            .map((item) => item['name'] as String),
      );

      final List<int> menuIds = List<int>.from(
        jsonResponse['result']['menuResponseListDTO']['menuQueryDTOList']
            .map((item) => item['menuId'] as int),
      );

      return Menu(ids: menuIds, names: menuNames);
    }
    print("ApiService : getDiets: response : $date $jsonResponse");
    // throw Error();
    return null;
  }

  static Future<void> postDiets(List<String> menuNameList, String date,
      String meals, int cafeteriaId, bool dayOff) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/";
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

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
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
      print('ApiService : getCongestionStatus : $jsonResponse');
      if (jsonResponse['result']['congestion'] != null) {
        return jsonResponse['result']['congestion'];
      }
    } else {
      print(jsonResponse);
    }
    return "선택 안함";
  }
}
