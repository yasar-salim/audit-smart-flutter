part of 'app_navigator_cubit.dart';

abstract class AppNavigatorState extends Equatable {
  const AppNavigatorState();
}

class AppNavigatorInitial extends AppNavigatorState {
  @override
  List<Object> get props => [];
}

class AppNavigatorSplash extends AppNavigatorState {
  final String route = Constants.SPLASH_ROUTE;

  @override
  List<Object> get props => [route];
}

class AppNavigatorAuthorization extends AppNavigatorState {
  final String route = Constants.LOGIN;

  @override
  List<Object> get props => [route];
}
class AppNavigatorSurveyProcessing extends AppNavigatorState {
  final String route = Constants.SURVEY_PROCESSING;

  @override
  List<Object> get props => [route];
}

class AppNavigatorSurveyStart extends AppNavigatorState {
  final String route = Constants.SURVEY_START;
  final SurveyResponse surveyResponse;

  AppNavigatorSurveyStart(this.surveyResponse);

  @override
  List<Object> get props => [route];
}


class AppNavigatorHome extends AppNavigatorState {
  final String routeUntil = Constants.HOME;
  final String route = Constants.HOME;
  AppNavigatorHome();

  @override
  List<Object> get props => [routeUntil];
}

class AppNavigatorNewSurveyFragment extends AppNavigatorState {
  @override
  List<Object> get props => [];
}

class AppNavigatorCompletedSurveyFragment extends AppNavigatorState {
  @override
  List<Object> get props => [];
}

class AppNavigatorProfileFragment extends AppNavigatorState {
  @override
  List<Object> get props => [];
}


class AppNavigatorSurveyQuestionnaire extends AppNavigatorState {
  final String route = Constants.SURVEY_QUESTIONNAIRE;
  final SurveyResponse surveyResponse;

  AppNavigatorSurveyQuestionnaire(this.surveyResponse);

  @override
  List<Object> get props => [route];
}

class AppNavigatorSurveySubmit extends AppNavigatorState {
  final String route = Constants.SURVEY_SUBMIT;
  final SurveyResponse surveyResponse;

  AppNavigatorSurveySubmit(this.surveyResponse);

  @override
  List<Object> get props => [route];
}

