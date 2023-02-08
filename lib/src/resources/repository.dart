import 'package:flutter/cupertino.dart';
import 'package:orison/src/models/audit_type_response.dart';
import 'package:orison/src/models/completed_survey_response.dart';
import 'package:orison/src/models/location_response.dart';
import 'package:orison/src/models/profile_response.dart';
import 'package:orison/src/models/signin_response.dart';
import 'package:orison/src/models/submit_response.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/models/user.dart';
import 'package:orison/src/resources/db_provider.dart';


import 'api_provider_profile.dart';
import 'shared_preferences_data_provider.dart';

class Repository {
  final _sharedPreferenceProvider = SharedPreferencesDataProvider();
  final _apiProviderProfile = ApiProviderProfile();
  final _dbProvider =  DBProvider.db;

  ///Shared Preferences
  Future<bool> saveAccessToken(String accessToken) =>
      _sharedPreferenceProvider.saveAccessToken(accessToken: accessToken);

  Future<String> getAccessToken() => _sharedPreferenceProvider.getAccessToken();

  Future<bool> saveUserId(int id) => _sharedPreferenceProvider.saveUserId(id);

  Future<int> getUserId() => _sharedPreferenceProvider.getUserId();

  Future<bool> saveUserName(String name) =>
      _sharedPreferenceProvider.saveUserName(name);

  Future<String> getUserName() => _sharedPreferenceProvider.getUserName();


  Future<bool> saveUserMail(String mail) =>
      _sharedPreferenceProvider.saveUserMail(mail);

  Future<String> getUserMail() => _sharedPreferenceProvider.getUserMail();

  Future<void> saveUser(User user) async {
    saveUserId(user.id);
    saveUserName(user.name);
    saveAccessToken(user.token);
    saveUserMail(user.email);
  }

  Future<User> getUser() async {
    User user = User();
    user.id = await getUserId();
    user.name = await getUserName();
    user.token = await getAccessToken();
    user.email = await getUserMail();
    return user;
  }

  Future<void> logoutUser() async {
    saveUserId(null);
    saveUserName(null);
    saveAccessToken(null);
    saveUserMail(null);
  }

  ///API Services
  Future<LocationResponse> fetchLocations() =>
      _apiProviderProfile.fetchLocations();

  Future<AuditTypesResponse> fetchAuditTypes() =>
      _apiProviderProfile.fetchAuditTypes();


  Future<SignInResponse> signIn({String email, String password}) =>
      _apiProviderProfile.signIn(
        email: email,
        password: password,
      );


  Future<SurveyResponse> createSurvey({Location location, AuditType auditType}) =>
      _apiProviderProfile.createSurvey(location: location,auditType: auditType);



  Future<SubmitResponse> submitAnswer(
      {int surveyId, Questions question, Function onProgress}) async {
    return _apiProviderProfile.submitAnswer(
      surveyId: surveyId, question: question,onProgress: onProgress);
  }

  Future<SubmitResponse> completeSurvey(
      {int surveyId}) async {
    return _apiProviderProfile.completeSurvey(
        surveyId: surveyId);
  }

  Future<CompletedSurveyResponse> getAllCompletedSurveys() =>
      _apiProviderProfile.getAllCompletedSurveys();

  Future<ProfileResponse> getProfile() =>
      _apiProviderProfile.getProfile();

  Future<SubmitResponse> logout() =>
      _apiProviderProfile.logout();

  Future<SubmitResponse> deleteSurveyFromServer(int id) async {
    return _apiProviderProfile.deleteSurvey(id: id);
  }

  /// local database
  Future<bool> saveSurvey({SurveyResponse surveyResponse}) async {
    return DBProvider.db.createSurvey(surveyResponse);
  }

  Future<List<SurveyResponse>> getAllProcessingSurveys() async {
    return DBProvider.db.getAllSurveys();
  }

  Future<SurveyResponse> getSurveyWithQuestions(int id) async {
    return DBProvider.db.getSurveyWithQuestions(id);
  }

  Future<bool> updateQuestion(int id,Questions question) async {
    return DBProvider.db.updateQuestion(id, question);
  }


  Future<SurveyResponse> getSurveyWithQuestionsForSubmit(int id) async {
    return DBProvider.db.getSurveyWithQuestionsForSubmit(id);
  }


  Future<bool> updateQuestionSubmitted(int id,Questions question) async {
    return DBProvider.db.updateQuestionSubmitted(id, question);
  }
  Future<bool> deleteSurvey(int id) async {
    return DBProvider.db.deleteSurvey(id);
  }
}
