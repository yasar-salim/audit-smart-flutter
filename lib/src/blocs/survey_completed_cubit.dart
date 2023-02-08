import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/completed_survey_response.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/resources/repository.dart';

part 'survey_completed_state.dart';

class SurveyCompletedCubit extends Cubit<SurveyCompletedState> {
  SurveyCompletedCubit() : super(SurveyCompletedInitial());

  final Repository _repository = Repository();

  Future<void> getSurveys() async {
    emit(SurveyCompletedBusy());
    try {
      CompletedSurveyResponse response =
          await _repository.getAllCompletedSurveys();
      if (response.status == 1) {
        emit(SurveyCompletedSuccess(response));
      } else
        emit(SurveyCompletedError());
    } catch (_) {
      // print(_.toString());
      emit(SurveyCompletedError());
    }
  }
}
