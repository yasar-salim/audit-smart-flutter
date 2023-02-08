import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/submit_response.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/resources/repository.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  SurveyCubit() : super(SurveyInitial());

  final Repository _repository = Repository();

  Future<void> getSurveyWithQuestions(id) async {
    emit(SurveyBusy());
    try {
      SurveyResponse response = await _repository.getSurveyWithQuestions(id);
      if (response != null) {
        emit(SurveySuccess(response));
      } else
        emit(SurveyError());
    } catch (_) {
      // print(_.toString());
      emit(SurveyError());
    }
  }

  Future<void> updateQuestion(int id, Questions question) async {
    await _repository.updateQuestion(id, question);
  }

  Future<void> validateSurvey(id) async {
    emit(SurveyValidationBusy());
    try {
      bool valid = true;
      SurveyResponse response = await _repository.getSurveyWithQuestions(id);
      for (int index = 0; index < response.questions.length; index++) {
        if (response.questions[index].visible == true) {
          // print(response.questions[index].toJson());
          if (response.questions[index].answers.length > 0) {
            for (var answer in response.questions[index].answers) {
              AnsOptions option = response.questions[index].options
                  .firstWhere((element) => element.id == answer.id);
              if (option.photoRequired == 1 && answer.images == null) {
                emit(SurveyValidationError(index,
                    "${response.questions[index].questionId}, for option '${option.option}' photo is required."));
                valid = false;
                break;
              }
              if (option.commentRequired == 1 &&
                  (answer.comment == null || answer.comment == "")) {
                emit(SurveyValidationError(index,
                    "${response.questions[index].questionId}, for option '${option.option}' comment is required."));
                valid = false;
                break;
              }
            }
          } else {
            emit(SurveyValidationError(index,
                "${response.questions[index].questionId} is unanswered. all the questions should be answered."));
            valid = false;
            break;
          }
        }
      }
      if (valid) emit(SurveyValidationSuccess(response));
    } catch (_) {
      print(_.toString());
      emit(SurveyValidationError(null, "Something went wrong!"));
    }
  }

  Future<void> submitSurvey(id) async {
    emit(SurveySubmitBusy());
    try {
      bool success = true;
      SurveyResponse response =
          await _repository.getSurveyWithQuestionsForSubmit(id);
      // print(response.questions.length);
      if (response.questions.length > 0) {
        for (int index = 0; index < response.questions.length; index++) {
          // api call for submit
          SubmitResponse responseSubmit = await _repository.submitAnswer(
              surveyId: id,
              question: response.questions[index],
              onProgress: (progress) {
                emitUploadProgress(
                    progress: progress,
                    total: response.questions.length,
                    current: index);
              });
          if (responseSubmit.status)
            _repository.updateQuestionSubmitted(id, response.questions[index]);
          else {
            emit(SurveySubmitError());
            success = false;
            break;
          }
        }
        if (success) {
          SubmitResponse responseComplete =
              await _repository.completeSurvey(surveyId: id);
          if (responseComplete.status) {
            await _repository.deleteSurvey(id);
            emit(SurveySubmitSuccess());
          } else {
            emit(SurveySubmitError());
            success = false;
          }
        }
      } else {
        SubmitResponse responseComplete =
            await _repository.completeSurvey(surveyId: id);
        if (responseComplete.status) {
          await _repository.deleteSurvey(id);
          emit(SurveySubmitSuccess());
        } else {
          emit(SurveySubmitError());
          success = false;
        }
      }
    } catch (_) {
      print(_.toString());
      emit(SurveySubmitError());
    }
  }

  void emitUploadProgress({int progress, int current, int total}) {
    emit(SurveySubmitBusyProgress(
        progress: progress, current: current, total: total));
  }

  Future<void> calculatePoints(SurveyResponse response) async {
    // print('inside calculate points');
    // print(response.questions.first.toJson().toString());
    // print(response.questions.first.options.last.points);
    int total = response.questions
        .map<int>((m) =>
            m.answers.length > 0 ? (m.visible == true ? m.points : 0) : 0)
        .reduce((a, b) => a + b);

    int earned = response.questions
        .map<int>((m) => m.answers.length > 0
            ? m.answers
                .map<int>((e) => (m.visible == true ? e.points : 0))
                .reduce((c, d) => c + d)
            : 0)
        .reduce((a, b) => a + b);

    // print(total.toString() + "/" + earned.toString());
    emit(SurveyPointsUpdated(total: total, earned: earned));
  }

  Future<void> incrementPoints(int total, int earned, int value) async {
    // print("increment" + value.toString());
    emit(SurveyPointsUpdated(total: total, earned: earned + value));
  }

  Future<void> decrementPoints(int total, int earned, int value) async {
    // print("decrement" + value.toString());
    emit(SurveyPointsUpdated(total: total, earned: (earned - value)));
  }

  Future<void> decrementAndIncrementPoints(
      int total, int earned, SurveyResponse survey) async {
    // print("update" + ((earned - dec) + inc).toString());

    total = survey.questions
        .map<int>((m) =>
            m.answers.length > 0 ? (m.visible == true ? m.points : 0) : 0)
        .reduce((a, b) => a + b);

    earned = survey.questions
        .map<int>((m) => m.answers.length > 0
            ? m.answers
                .map<int>((e) => (m.visible == true ? e.points : 0))
                .reduce((c, d) => c + d)
            : 0)
        .reduce((a, b) => a + b);

    emit(SurveyPointsUpdated(total: total, earned: earned));
  }
}
