import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/resources/repository.dart';

part 'survey_processing_state.dart';

class SurveyProcessingCubit extends Cubit<SurveyProcessingState> {
  SurveyProcessingCubit() : super(SurveyProcessingInitial());
  final Repository _repository = Repository();

  Future<void> getSurveys() async {
    emit(SurveyProcessingBusy());
    try {
      List<SurveyResponse> response =
          await _repository.getAllProcessingSurveys();
      if (response != null) {
        emit(SurveyProcessingSuccess(response));
      } else
        emit(SurveyProcessingError());
    } catch (_) {
      // print(_.toString());
      emit(SurveyProcessingError());
    }
  }

  Future<void> deleteSurvey(int id) async {
    try {
      bool response = await _repository.deleteSurvey(id);
      // _repository.deleteSurveyFromServer(id);

      // print(response);
      if (response) {
        emit(SurveyProcessingDeleteSuccess());
      } else
        emit(SurveyProcessingDeleteError());
    } catch (_) {
      // print(_.toString());
      emit(SurveyProcessingDeleteError());
    }
  }
}
