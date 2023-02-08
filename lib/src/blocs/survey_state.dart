part of 'survey_cubit.dart';

abstract class SurveyState extends Equatable {
  const SurveyState();
}

class SurveyInitial extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveyBusy extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveyError extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveySuccess extends SurveyState {
  final SurveyResponse response;

  SurveySuccess(this.response);
  @override
  List<Object> get props => [];
}

class SurveyValidationBusy extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveyValidationError extends SurveyState {
  final int index;
  final String message;

  SurveyValidationError(this.index, this.message);
  @override
  List<Object> get props => [];
}

class SurveyValidationSuccess extends SurveyState {
  final SurveyResponse response;

  SurveyValidationSuccess(this.response);
  @override
  List<Object> get props => [];
}

class SurveySubmitBusy extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveySubmitError extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveySubmitSuccess extends SurveyState {
  @override
  List<Object> get props => [];
}

class SurveySubmitBusyProgress extends SurveyState {
  final int progress;
  final int current;
  final int total;

  SurveySubmitBusyProgress({
    this.progress = 0,
    this.current,
    this.total,
  });
  @override
  List<Object> get props => [progress];
}

class SurveyPointsUpdated extends SurveyState {
  final int earned;
  final int total;

  SurveyPointsUpdated({this.earned, this.total});
  @override
  List<Object> get props => [earned, total];
}
