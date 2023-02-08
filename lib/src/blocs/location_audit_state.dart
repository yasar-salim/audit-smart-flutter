part of 'location_audit_cubit.dart';

abstract class LocationAuditState extends Equatable {
  const LocationAuditState();
}

class LocationAuditInitial extends LocationAuditState {
  @override
  List<Object> get props => [];
}


class LocationAuditBusy extends LocationAuditState {
  @override
  List<Object> get props => [];
}

class LocationAuditSuccess extends LocationAuditState {
  final List<Location> locations;
  final List<AuditType> auditTypes;

  LocationAuditSuccess(this.locations,this.auditTypes);

  @override
  List<Object> get props => [locations,auditTypes];
}


class LocationAuditError extends LocationAuditState {
  @override
  List<Object> get props => [];
}


class LocationAuditSurveyBusy extends LocationAuditState {
  @override
  List<Object> get props => [];
}

class LocationAuditSurveyError extends LocationAuditState {
  @override
  List<Object> get props => [];
}
class LocationAuditSurveySuccess extends LocationAuditState {
  final SurveyResponse response;

  LocationAuditSurveySuccess(this.response);
  @override
  List<Object> get props => [response];
}

class LocationAuditSurveyValidationError extends LocationAuditState {
  final  int field;

  LocationAuditSurveyValidationError(this.field);

  @override
  List<Object> get props => [field];
}
