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
    const dietId = 4;
    final url = Uri.http(baseUrl, "/diets/$dietId/dietPhoto");

    // 파일의 MIME 타입을 결정합니다.
    String? mimeType = lookupMimeType(image.path);
    var mimeeTypeSplit =
        mimeType?.split('/') ?? ['application', 'octet-stream']; // 기본값을 제공합니다.

    // 이미지 파일의 바이트 데이터를 읽습니다.
    var imageBytes = await image.readAsBytes();

    // MultipartRequest 객체를 생성합니다.
    var request = http.MultipartRequest('POST', url);

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
    const int cafeterialId = 1;
    const path = "/menus";
    final url = Uri.http(baseUrl, path, {'cafeteriaId': '$cafeterialId'});

    final response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=UTF-8'});

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

  static Future<Menu> getDiets(String date, String meals) async {
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

    final response = await http
        .get(url, headers: {'Content-Type': 'application/json; charset=UTF-8'});

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

  static Future<void> postDiets(List<String> menuIdList, String date,
      String meals, int cafeteriaId, bool dayOff) async {
    const path = "/admin/diets/";
    final url = Uri.http(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json', // JSON 형식의 데이터를 전송한다고 명시합니다.
        },
        body: jsonEncode(
          {
            'menuIdList': menuIdList,
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

  // static Future<void> _setLogin(String accessToken, String refreshToken) async {
  //   // 공유저장소에 유저 DB의 인덱스 저장
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('accessToken', accessToken);
  //   prefs.setString('refreshToken', refreshToken);
  // }

  // static void delAutoLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('accessToken');
  // }
}
