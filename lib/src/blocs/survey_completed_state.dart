part of 'survey_completed_cubit.dart';

abstract class SurveyCompletedState extends Equatable {
  const SurveyCompletedState();
}

class SurveyCompletedInitial extends SurveyCompletedState {
  @override
  List<Object> get props => [];
}


class SurveyCompletedBusy extends SurveyCompletedState {
  @override
  List<Object> get props => [];
}
class SurveyCompletedError extends SurveyCompletedState {
  @override
  List<Object> get props => [];
}

class SurveyCompletedSuccess extends SurveyCompletedState {
  final CompletedSurveyResponse response;

  SurveyCompletedSuccess(this.response);
  @override
  List<Object> get props => [];
}
