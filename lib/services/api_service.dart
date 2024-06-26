import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:tam_cafeteria_front/models/covers_model.dart';
import 'package:tam_cafeteria_front/models/diet_model.dart';
import 'package:tam_cafeteria_front/models/cafeteria_model.dart';
import 'package:tam_cafeteria_front/models/notification_model.dart';
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
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/menus";
    final url = Uri.https(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken' // JSON 형식의 데이터를 전송한다고 명시합니다.
        },
        body: jsonEncode(
          {
            'menuName': name,
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
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<Diet> getMenu(int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/menus";
    final url = Uri.https(baseUrl, path, {'cafeteriaId': '$cafeteriaId'});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      // UTF-8 인코딩을 사용하여 응답 본문을 디코드합니다.
      final String decodedResponse = utf8.decode(response.bodyBytes);

      // 디코드된 문자열을 JSON으로 파싱합니다.
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      // TODO : null 왔을때 대처
      // 'result' 키에 해당하는 부분을 추출하고, 'menuQueryDTOList' 내부를 순회하며 각 항목의 'name'을 추출하여 리스트를 생성합니다.
      print('getMenu : $jsonResponse');
      final List<String> menuNames =
          jsonResponse['result']['menuQueryDTOList'] != null
              ? List<String>.from(
                  jsonResponse['result']['menuQueryDTOList']
                      .map((item) => (item['name'] ?? "")),
                )
              : [];

      final List<int> menuIds =
          jsonResponse['result']['menuQueryDTOList'] != null
              ? List<int>.from(
                  jsonResponse['result']['menuQueryDTOList']
                      .map((item) => (item['menuId']) as int),
                )
              : [];

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
    final url = Uri.https(
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
    final url = Uri.https(baseUrl, path);

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
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> putDiets(
      String menuName, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/menus";
    final url = Uri.https(baseUrl, path);

    final response = await http.put(
      url,
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
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('putDiets : $jsonResponse');
    } else {
      print('putDiets : $jsonResponse');
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> deleteDiets(
      String menuName, String date, String meals, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/menus";
    final url = Uri.https(baseUrl, path);

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
      print('deleteDiet : $jsonResponse');
    } else {
      print('putDiets : $jsonResponse');
      throw Exception(jsonResponse['message']);
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

  static Future<String?> postKakaoLogin(
      String idToken, String accessToken) async {
    const path = '/oauth2/kakao/token/validate';
    final url = Uri.https(baseUrl, path);

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
      // print(jsonResponse);
      // return jsonResponse['message'];
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<String> postEmailAuthCode(String email) async {
    const path = '/auth/email';
    final url = Uri.https(baseUrl, path);

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
      // print(jsonResponse);

      return 'true';
    } else {
      // print(jsonResponse);
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<bool> postEmailVerification(
      String email, String authCode) async {
    const path = '/auth/email/verification';
    final url = Uri.https(baseUrl, path);

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
      // print(jsonResponse);
      return true;
    } else {
      // print(jsonResponse);
      return false;
    }
  }

  static Future<bool> postSignUp(
      String name, String password, String email, String authcode) async {
    const path = "/sign-up";
    final url = Uri.https(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
        },
        body: jsonEncode(
          {
            'name': name,
            'password': password,
            'email': email,
            'authCode': authcode,
          },
        ));
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<String?> postSignIn(String email, String password) async {
    const path = "/auth/email/sign-in";
    final url = Uri.https(baseUrl, path);

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
      // return jsonResponse['message'];
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> postCongestionStatus(
      String? congestion, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/admin/cafeterias/$cafeteriaId/congestion";
    final url = Uri.https(baseUrl, path);

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
      // return jsonResponse['message'];
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<String> getCongestionStatus(int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/cafeterias/$cafeteriaId/congestion";
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
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      if (jsonResponse['result']['congestion'] != null) {
        return jsonResponse['result']['congestion'];
      }
    } else {}
    return "운영안함";
  }

  //

  static Future<String?> postAppleLogin(
      String? socialId, String? identityToken, String authorizationCode) async {
    const path = '/oauth2/apple/token/validate';
    final url = Uri.https(baseUrl, path);

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
      // return jsonResponse['message'];
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> patchDayOffStatus(
      int cafeteriaId, String date, String meals) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/dayOff";
    final url = Uri.https(baseUrl, path);

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
          'meals': meals,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // print('ApiService : getCongestionStatus : $jsonResponse');
      print(
          'ApiService : pathDayOffStatus ${jsonResponse['result']['dayOff']}');
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<bool> patchSoldOutStatus(
      int cafeteriaId, String date, String meals) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/diets/sold-out";
    final url = Uri.https(baseUrl, path);

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
          'meals': meals,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // print('ApiService : getCongestionStatus : $jsonResponse');
      print(
          'ApiService : pathSoldOutStatus ${jsonResponse['result']['soldOut']}');
      return jsonResponse['result']['soldOut'];
    } else {
      throw Exception(jsonResponse['message']);
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
    final url = Uri.https(baseUrl, path, queryParameters);

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
    } else {}
    return {};
  }

  static Future<void> postNotificationToSubscriber(String title, String content,
      String cafeteriaName, String notificationType) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/notifications/topic/subscriber";
    final url = Uri.https(baseUrl, path);

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
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> postNotificationSet(String registrationToken) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notificationSet";
    final url = Uri.https(
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
      print('ApiService : postNotificationSet : $jsonResponse');
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> putRegistrationToken(String registrationToken) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notificationSet/registration-token";
    final url = Uri.https(
      baseUrl,
      path,
      {
        "registrationToken": registrationToken,
      },
    );

    final response = await http.put(
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
      print(
          'ApiService : putRegistrationToken : $registrationToken, $jsonResponse');
    } else {
      print('ApiService : putRegistrationToken : $jsonResponse');
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<String?> getRegistrationToken() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notificationSet/registration-token";
    final url = Uri.https(
      baseUrl,
      path,
    );

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
      return jsonResponse['result']['registrationToken'];
    } else {
      // print('ApiService : putRegistrationToken : $jsonResponse');
    }
    throw Exception(jsonResponse['message']);
  }

  static Future<void> postNotificationToAllUser(
      String title, String content) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/notifications/users";
    final url = Uri.https(baseUrl, path);

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
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<List<NotificationModel>> getNotifications() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notifications";
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
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // print('ApiService : getNotifications : $jsonResponse');
      List<dynamic> resultList = jsonResponse['result']['notificationList'];
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
    } else {
      // return jsonResponse['message'];
    }
    return [];
  }

  static Future<void> postNotificationToServer(String notificationId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/users/notifications/$notificationId";
    final url = Uri.https(baseUrl, path);

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
      // throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> deleteOneNotification(String notificationId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/users/notifications/$notificationId";
    final url = Uri.https(baseUrl, path);

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
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> deleteAllNotification() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notifications";
    final url = Uri.https(baseUrl, path);

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
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> readOneNotification(String notificationId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/users/notifications/$notificationId/read";
    final url = Uri.https(baseUrl, path);

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
    } else {}
  }

  ///admin user 조회 api 연동

  static Future<List<User>> getUsers(int page) async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken();
      if (accessToken == null) {
        throw Exception('Access token is null');
      }
      final url = Uri.https(baseUrl, '/admin', {'page': page.toString()});

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // 여기에서 중복된 'Bearer'를 제거했습니다.
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<User> users = List<User>.from(
            data["result"]["userList"].map((x) => User.fromJson(x)));
        return users;
      } else {
        print(
            'API Service: getUsers: Error with status code: ${response.statusCode}');
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('API Service: getUsers: Exception caught: $e');
      rethrow; // 예외를 다시 던지도록 변경
    }
  }

  static Future<void> revokeAdminRole(int userId) async {
    try {
      final url = Uri.https(baseUrl, '/admin/users/$userId/role/user');
      final accessToken =
          await TokenManagerWithSP.loadToken(); // 토큰 로드 로직 구현 필요
      if (accessToken == null) {
        throw Exception('Access token is null');
      }

      final response = await http.patch(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        print('관리자 권한 회수 성공: ${response.body}');
      } else {
        print('관리자 권한 회수 실패: ${response.statusCode}');
        throw Exception('Failed to revoke admin role');
      }
    } catch (e) {
      print('관리자 권한 회수 중 예외 발생: $e');
      rethrow;
    }
  }

  static Future<bool> grantAdminRole(int userId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final url = Uri.https(baseUrl, '/admin/users/$userId/role/admin');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    // 응답 상태 코드와 응답 본문을 출력합니다.
    // 응답 상태 코드와 응답 본문을 출력합니다.
    print('Status code: ${response.statusCode}');
    print('Response body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      // 'isSuccess' 키의 존재 여부와 값을 확인합니다.
      if (responseBody.containsKey('isSuccess') && responseBody['isSuccess']) {
        return true;
      } else {
        // 'isSuccess'가 false이거나 키가 없는 경우, 실패 사유를 로그로 남깁니다.
        print(
            'Failed to grant admin role. Response: ${utf8.decode(response.bodyBytes)}');
        return false;
      }
    } else {
      // 오류 처리를 위한 예외를 던집니다. 응답 상태 코드를 포함시켜 구체적인 오류 사유를 알 수 있게 합니다.
      throw Exception(
          'Failed to grant admin role. Status code: ${response.statusCode}');
    }
  }

  static Future<void> readAllNotification() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/notifications/read";
    final url = Uri.https(baseUrl, path);

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
      print('ApiService : readAllNotification : $jsonResponse');
    } else {
      print(jsonResponse);
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> postAddCafeteria(
      String name,
      String location,
      bool runBreakfast,
      bool runLunch,
      String? breakfastTime,
      String? lunchTime) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/admin/cafeterias";
    final url = Uri.https(baseUrl, path);
    String breakfastStart = "";
    String breakfastEnd = "";
    String lunchStart = "";
    String lunchEnd = "";
    if (runBreakfast) {
      String start = breakfastTime!.split("~")[0];

      breakfastStart = "$start:00"; // hour 변수의 값을 할당합니다.

      String end = breakfastTime.split("~")[1];
      // second는 0을 할당합니다.
      breakfastEnd = "$end:00";
    }
    if (runLunch) {
      String start = lunchTime!.split("~")[0];
      // second는 0을 할당합니다.
      lunchStart = "$start:00";

      String end = lunchTime.split("~")[1];
      // second는 0을 할당합니다.
      lunchEnd = "$end:00";
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(
        {
          "name": name,
          "location": location,
          'runBreakfast': runBreakfast,
          'runLunch': runLunch,
          "breakfastStartTime": breakfastStart,
          "breakfastEndTime": breakfastEnd,
          "lunchStartTime": lunchStart,
          "lunchEndTime": lunchEnd,
        },
      ),
    );

    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : postAddCafeteria : $jsonResponse');
    } else {
      print(jsonResponse);
      throw Exception(jsonResponse['message']);
    }
  }

  //1. 식당을 조회해서 이제 그 유저관리 페이지 다이얼로그에 띄운다.
  Future<List<Cafeteria>> getCafeteriaList() async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken(); // 토큰 관리 로직 추가
      final Uri url = Uri.https(baseUrl, '/admin/me/cafeterias');

      print('Fetching cafeteria list from: $url');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('Response status code: ${response.statusCode}'); // 응답 상태 코드 출력
      print(
          'Response body: ${utf8.decode(response.bodyBytes)}'); // UTF-8로 디코딩된 응답 본문 출력

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes))['result']
            ['queryCafeteriaList'] as List<dynamic>;
        return data.map((item) => Cafeteria.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch cafeteria list');
      }
    } catch (e) {
      print('Error fetching cafeteria list: $e'); // 오류 발생 시 출력
      rethrow;
    }
  }

//알람 api
  static Future<Map<String, bool>> getNotificationSettings() async {
    final accessToken = await TokenManagerWithSP.loadToken();

    const path = "/users/notificationSet";
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
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // 필요에 따라 JSON 응답을 처리합니다.
      if (jsonResponse['result'] != null && jsonResponse['result'] is Map) {
        final Map<String, dynamic> resultMap = jsonResponse['result'];

        // resultMap의 모든 요소를 순회하며, bool 타입만을 포함하는 새로운 Map을 생성합니다.
        final Map<String, bool> result = {};
        resultMap.forEach((key, value) {
          // 값이 bool 타입인지 확인합니다.
          if (value is bool) {
            result[key] = value;
          } else {
            // bool 타입이 아닌 경우, 적절히 처리합니다. (예: 오류 로그를 남김)
            print("Warning: The value for '$key' is not a bool.");
          }
        });
        return result;
        // 여기서 'result'는 Map<String, bool> 타입입니다.
        // 필요에 따라 'result'를 사용합니다.
      }
    } else {
      print('getNotificationSetting : ${jsonResponse['message']}');
    }
    return {};
  }

  static Future<void> updateNotificationSettings(
      Map<String, bool> newSettings) async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken();

      const path = "/users/notificationSet";
      final url = Uri.https(baseUrl, path);

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(newSettings),
      );

      final String decodedResponse = utf8.decode(response.bodyBytes);

      // 디코드된 문자열을 JSON으로 파싱합니다.
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

      if (response.statusCode == 200) {
        // 필요에 따라 JSON 응답을 처리합니다.
      } else {
        print('상태 코드: ${response.statusCode}로 요청이 실패했습니다.');
        throw Exception(jsonResponse['message']);
      }
    } catch (error) {
      print('오류 발생: $error');
    }
  }

  static Future<dynamic> getUserInfo() async {
    final accessToken = await TokenManagerWithSP.loadToken();

    const path = "/users/me";
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
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // 필요에 따라 JSON 응답을 처리합니다.
      return jsonResponse['result'];
    } else {
      print('상태 코드: ${response.statusCode}로 요청이 실패했습니다.');
    }
    return null;
  }

  static Future<void> deleteUser() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/users/me";
    final url = Uri.https(baseUrl, path);

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
        'Authorization': 'Bearer $accessToken',
      },
    );
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('deleteUser : $jsonResponse');
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> deleteLogOut() async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/logout";
    final url = Uri.https(baseUrl, path);

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        // accessToken을 Authorization 헤더에 Bearer 토큰으로 추가
        'Authorization': 'Bearer $accessToken',
      },
    );
    final String decodedResponse = utf8.decode(response.bodyBytes);

    // 디코드된 문자열을 JSON으로 파싱합니다.
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('logout : $jsonResponse');
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  Future<List<Map<String, dynamic>>> fetchMenuBoardList(
    int cafeteriaId,
    int page,
    String orderType,
  ) async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken();
      const path = "/posts/menu-request";
      // cafeteriaId를 쿼리 파라미터에 추가
      final url = Uri.https(baseUrl, path, {
        'cafeteriaId': '$cafeteriaId',
        'page': '$page',
        'orderType': orderType,
      });

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8로 디코딩
        final String responseUtf8 = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = jsonDecode(responseUtf8);
        final List<dynamic> resultList =
            jsonResponse['result']['postPreviewDTOList'];
        final int lastPage = jsonResponse['result']['totalPages'];
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
    } catch (e) {
      print('오류 발생: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchNoticeBoardList(
    int cafeteriaId,
    int page,
  ) async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken();
      const path = "/posts/notice";
      // cafeteriaId를 쿼리 파라미터에 추가
      final url = Uri.https(baseUrl, path, {
        'cafeteriaId': '$cafeteriaId',
        'page': '$page',
      });

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8로 디코딩
        final String responseUtf8 = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = jsonDecode(responseUtf8);
        final List<dynamic> resultList =
            jsonResponse['result']['postPreviewDTOList'];
        final int lastPage = jsonResponse['result']['totalPages'];
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
    } catch (e) {
      print('오류 발생: $e');
      return [];
    }
  }

  static Future<void> createPost(
      String boardType, String title, String content, int cafeteriaId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    const path = "/posts";
    final url = Uri.https(baseUrl, path);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          {
            "boardType": boardType,
            "title": title,
            "content": content,
            "cafeteriaId": cafeteriaId,
          },
        ));

    final String decodedResponse = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : createPost : $jsonResponse');
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> togglePostLike(int postId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/posts/$postId/like";
    final url = Uri.https(baseUrl, path);

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    final String decodedResponse = utf8.decode(response.bodyBytes);

    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService : togglePostLike : $jsonResponse');
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<Map<String, dynamic>> fetchBoardDetail(int id) async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken();
      final path = "/posts/$id";
      final url = Uri.https(baseUrl, path);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final String responseUtf8 = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = jsonDecode(responseUtf8);
        return jsonResponse['result'];
      } else {
        print('상태 코드: ${response.statusCode}로 요청이 실패했습니다.');
        return {};
      }
    } catch (e) {
      print('오류 발생: $e');
      return {};
    }
  }

  static Future<void> deletePost(int postId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final path = "/posts/$postId";
    final url = Uri.https(baseUrl, path);

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    final String decodedResponse = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('deletePost : $jsonResponse');
    } else {
      print('Error in deletePost : $jsonResponse');
      throw Exception(jsonResponse['message']);
    }
  }

  static Future<void> updatePost(
      int postId, String newTitle, String newContent) async {
    try {
      final accessToken = await TokenManagerWithSP.loadToken();
      final String path = "/posts/$postId";
      final Uri url = Uri.https(baseUrl, path);

      final Map<String, String> requestBody = {
        'title': newTitle,
        'content': newContent,
      };
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(requestBody),
      );
      final String decodedResponse = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      if (response.statusCode == 200) {
        print('게시글이 성공적으로 수정되었습니다: $jsonResponse');
      } else {
        print('상태 코드: ${response.statusCode}로 요청이 실패했습니다.');
        throw Exception(jsonResponse['message']);
      }
    } catch (error) {
      print('오류 발생: $error');
    }
  }

  static Future<void> reportPost(int postId) async {
    final accessToken = await TokenManagerWithSP.loadToken();
    final url = Uri.https(baseUrl, '/posts/$postId/report');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'id': postId,
      }),
    );

    final decodedResponse = utf8.decode(response.bodyBytes);
    final jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      print('ApiService: reportPost: $jsonResponse');
    } else {
      throw Exception(jsonResponse['message']);
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
