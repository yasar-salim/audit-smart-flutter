part of 'survey_processing_cubit.dart';

abstract class SurveyProcessingState extends Equatable {
  const SurveyProcessingState();
}

class SurveyProcessingInitial extends SurveyProcessingState {
  @override
  List<Object> get props => [];
}

class SurveyProcessingBusy extends SurveyProcessingState {
  @override
  List<Object> get props => [];
}
class SurveyProcessingError extends SurveyProcessingState {
  @override
  List<Object> get props => [];
}

class SurveyProcessingSuccess extends SurveyProcessingState {
  final List<SurveyResponse> response;

  SurveyProcessingSuccess(this.response);
  @override
  List<Object> get props => [];
}

class SurveyProcessingDeleteError extends SurveyProcessingState {
  @override
  List<Object> get props => [];
}

class SurveyProcessingDeleteSuccess extends SurveyProcessingState {
  @override
  List<Object> get props => [];
}
