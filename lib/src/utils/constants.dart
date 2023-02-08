class Constants {

  ///API constants
  static const String SERVER = 'https://smartaudit.orison.com.au/api/';

  //////////////////////APIs//////////////////////////////////

  ///[API_LOGIN] POST method
  static const String API_LOGIN = SERVER + 'login';
  ///[API_LOCATIONS] POST method
  static const String API_LOCATIONS = SERVER + 'locations';
  ///[API_AUDIT_TYPES] POST method
  static const String API_AUDIT_TYPES = SERVER + 'auditTypes';
  ///[API_CREATE_SURVEY] POST method
  static const String API_CREATE_SURVEY = SERVER + 'createSurvey';
  ///[API_COMPLETE_SURVEY] POST method
  static const String API_COMPLETE_SURVEY = SERVER + 'completeSurvey';
  ///[API_COMPLETED_SURVEY] POST method
  static const String API_COMPLETED_SURVEY = SERVER + 'completedSurveys';
  ///[API_PROFILE] POST method
  static const String API_PROFILE = SERVER + 'profile';
  ///[API_LOGOUT] POST method
  static const String API_LOGOUT = SERVER + 'logout';
  ///[API_SURVEY_DELETE] POST method
  static const String API_SURVEY_DELETE = SERVER + 'surveyDelete';

  ///[UPDATE_PROFILE] POST method
  static const String UPDATE_PROFILE = SERVER + 'users/me/';



  /// All the routing constants used within the app
  static const String SPLASH_ROUTE = '/';
  static const String LOGIN = '/login';
  static const String FORGOT_PASSWORD = '/forgot_password';
  static const String HOME = '/home';
  static const String SURVEY_START = '/survey_start';
  static const String SURVEY_QUESTIONNAIRE = '/survey_questionnaire';
  static const String SURVEY_SUBMIT = '/survey_submit';
  static const String SURVEY_PROCESSING = '/survey_processing';
}
