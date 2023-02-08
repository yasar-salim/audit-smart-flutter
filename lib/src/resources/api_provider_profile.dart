import 'dart:convert';
import 'dart:developer';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:orison/src/models/audit_type_response.dart';
import 'package:orison/src/models/completed_survey_response.dart';
import 'package:orison/src/models/location_response.dart';
import 'package:orison/src/models/profile_response.dart';
import 'package:orison/src/models/signin_response.dart';
import 'package:orison/src/models/submit_response.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/resources/repository.dart';
import 'package:orison/src/utils/constants.dart';

class ApiProviderProfile {
  static const int SUCCESS = 200;
  static const int UNAUTHORIZED = 401;

  ///[Accesstocken] is a must for all APIs as Header
  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  ///Fetch all available locations
  Future<LocationResponse> fetchLocations() async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();

    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
    };
    final response = await http.post(Uri.parse(Constants.API_LOCATIONS),
        headers: header, body: jsonEncode(body));

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return LocationResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  ///Fetch all available audit types
  Future<AuditTypesResponse> fetchAuditTypes() async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
    };
    final response = await http.post(Uri.parse(Constants.API_AUDIT_TYPES),
        headers: header, body: jsonEncode(body));
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return AuditTypesResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  Future<SignInResponse> signIn({String email, String password}) async {
    Map<String, String> body = {
      'username': email,
      'password': password,
    };
    final response = await http.post(Uri.parse(Constants.API_LOGIN),
        headers: header, body: json.encode(body).toString());
    // print(response.body);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return SignInResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  ///create survey
  Future<SurveyResponse> createSurvey(
      {Location location, AuditType auditType}) async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'location_id': location.siteid,
      'audit_type': auditType.id.toString(),
      'token': token,
    };
    print(body);
    final response = await http.post(Uri.parse(Constants.API_CREATE_SURVEY),
        body: json.encode(body).toString(), headers: header);
    // print(response.body);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);

      // adding visible flag to each question start
      // final List<dynamic> questions = responseString['questions'];
      responseString['questions']
          .map((question) => question['visible'] = true)
          .toList();
      // responseString['questions'] = questions;
      // adding visible flag to each question ends

      // responseString['questions'][0]['visible'] = false;
      print(responseString['questions'][0]);

      responseString['site_id'] = location.siteid.toString();
      responseString['site_name'] = location.name;
      responseString['audit_type_id'] = auditType.id;
      responseString['audit_type_name'] = auditType.name;

      return SurveyResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  Future<SubmitResponse> submitAnswer(
      {int surveyId, Questions question, Function onProgress}) async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();

    Map<String, dynamic> data = {
      'survey_id': surveyId,
      'question_id': question.id,
      'options': jsonEncode(question.answers),
    };

    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
      'data': json.encode(data)
    };

    // print(body.toString());
    // dio
    var formData = FormData();
    formData.fields.addAll(body.entries);
    for (var i = 0; i < question.answers.length; i++) {
      if (question.answers[i].images != null) {
        for (Image image in question.answers[i].images) {
          // print(image.id.toString());
          formData.files.add(MapEntry(
            '${image.id}',
            await MultipartFile.fromFile(image.image,
                filename: image.image.split("/").last,
                contentType: MediaType("image", "jpeg")),
          ));
        }
      }
    }
    var dio = Dio();
    Response response = await dio.post(
      Constants.SERVER+"saveSurveyAnswers",
      options: Options(
          /*headers: header,*/
          method: "POST",
          contentType: 'multipart/form-data'),
      data: formData,
      onSendProgress: (int sent, int total) {
        if (total != -1) {
          // print((sent / total * 100).toStringAsFixed(0) + '%');
          onProgress.call(int.parse((sent / total * 100).toStringAsFixed(0)));
        }
      },
    );

    // print(response.statusCode);
    // print(response.data);
    if (response.statusCode == SUCCESS) {
      var responseString = response.data;
      responseString['code'] = response.statusCode;
      return SubmitResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  ///complete survey
  Future<SubmitResponse> completeSurvey({int surveyId}) async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'survey_id': surveyId.toString(),
      'token': token,
    };
    final response = await http.post(Uri.parse(Constants.API_COMPLETE_SURVEY),
        body: json.encode(body).toString(), headers: header);
    print(response.body);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return SubmitResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  ///Fetch all completed surveys
  Future<CompletedSurveyResponse> getAllCompletedSurveys() async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
    };
    final response = await http.post(Uri.parse(Constants.API_COMPLETED_SURVEY),
        body: json.encode(body).toString(), headers: header);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return CompletedSurveyResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  ///Fetch profile
  Future<ProfileResponse> getProfile() async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
    };
    final response = await http.post(Uri.parse(Constants.API_PROFILE),
        body: json.encode(body).toString(), headers: header);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return ProfileResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  /// logout
  Future<SubmitResponse> logout() async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
    };
    final response = await http.post(Uri.parse(Constants.API_LOGOUT),
        body: json.encode(body).toString(), headers: header);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return SubmitResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load');
    }
  }

  /// logout
  Future<SubmitResponse> deleteSurvey({int id}) async {
    final String token = await Repository().getAccessToken();
    final int userId = await Repository().getUserId();
    Map<String, String> body = {
      'user_id': userId.toString(),
      'token': token,
      'id': id.toString()
    };
    final response = await http.post(Uri.parse(Constants.API_SURVEY_DELETE),
        body: json.encode(body).toString(), headers: header);
    if (response.statusCode == SUCCESS) {
      final responseString = jsonDecode(response.body);
      return SubmitResponse.fromJson(responseString);
    } else {
      log('error', error: response.body, time: DateTime.now());
      throw Exception('failed to load');
    }
  }
}
