import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/audit_type_response.dart';
import 'package:orison/src/models/location_response.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/resources/repository.dart';

part 'location_audit_state.dart';

class LocationAuditCubit extends Cubit<LocationAuditState> {
  LocationAuditCubit() : super(LocationAuditInitial());

  final Repository _repository = Repository();

  Future<void> getLocationsAndAuditTypes() async {
    emit(LocationAuditBusy());
    try {
      LocationResponse locationResponse; //= await _repository.fetchLocations();
      AuditTypesResponse
          auditTypeResponse; //= await _repository.fetchAuditTypes();
      List<dynamic> response = await Future.wait([
        _repository.fetchLocations(),
        _repository.fetchAuditTypes(),
      ]);
      locationResponse = response[0];
      auditTypeResponse = response[1];
      if ((locationResponse != null && locationResponse.status == 1) &&
          (auditTypeResponse != null && auditTypeResponse.status == 1)) {
        emit(LocationAuditSuccess(
            locationResponse.locations, auditTypeResponse.auditTypes));
      } else
        emit(LocationAuditError());
    } catch (_) {
      // print(_.toString());
      emit(LocationAuditError());
    }
  }

  void getSurvey({Location location, AuditType auditType}) async {
    emit(LocationAuditSurveyBusy());
    if (validateFields(location: location, auditType: auditType)) {
      try {
        SurveyResponse response = await _repository.createSurvey(
            location: location, auditType: auditType);
        if (response.status == 1) {
          await _repository.saveSurvey(surveyResponse: response);
          emit(LocationAuditSurveySuccess(response));
        } else {
          emit(LocationAuditSurveyError());
        }
      } catch (_) {
        print(_.toString());
        emit(LocationAuditSurveyError());
      }
    }
  }

  bool validateFields({
    Location location,
    AuditType auditType,
  }) {
    if (location == null) {
      emit(LocationAuditSurveyValidationError(1));
      return false;
    }
    if (auditType == null) {
      emit(LocationAuditSurveyValidationError(2));
      return false;
    }
    return true;
  }
}
