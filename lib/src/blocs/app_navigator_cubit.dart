import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/utils/constants.dart';


part 'app_navigator_state.dart';

class AppNavigatorCubit extends Cubit<AppNavigatorState> {
  AppNavigatorCubit() : super(AppNavigatorInitial());

  routeToAuthorization() {
    emit(AppNavigatorAuthorization());
  }

  routeToHome() {
    emit(AppNavigatorHome());
    emit(AppNavigatorInitial());
  }

  routeToNewSurveyFragment() {
    emit(AppNavigatorNewSurveyFragment());
    emit(AppNavigatorInitial());
  }
  routeToCompletedSurveyFragment() {
    emit(AppNavigatorCompletedSurveyFragment());
    emit(AppNavigatorInitial());
  }
  routeToProfileFragment() {
    emit(AppNavigatorProfileFragment());
    emit(AppNavigatorInitial());
  }

  routeToSurveyProcessing() {
    emit(AppNavigatorSurveyProcessing());
    emit(AppNavigatorInitial());
  }

  routeToSurveyStart({SurveyResponse response}) {
    emit(AppNavigatorSurveyStart(response));
    emit(AppNavigatorInitial());
  }

  routeToSurveyQuestionnaire({SurveyResponse response}) {
    emit(AppNavigatorSurveyQuestionnaire(response));
    emit(AppNavigatorInitial());
  }

  routeToSurveySubmit({SurveyResponse response}) {
    emit(AppNavigatorSurveySubmit(response));
    emit(AppNavigatorInitial());
  }

}
