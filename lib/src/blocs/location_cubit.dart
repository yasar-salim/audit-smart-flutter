import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/location_response.dart';
import 'package:orison/src/resources/repository.dart';


part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());
  final Repository _repository = Repository();

  Future<void> getLocations() async {
    emit(LocationsFetchInProgress());
    try {
      LocationResponse response = await _repository.fetchLocations();
      if (response != null && response.status==1) {
        if (response.locations.isNotEmpty)
          emit(LocationsFetchSuccess(response.locations));
        else
          emit(LocationsFetchEmpty());
      } else
        emit(LocationsFetchFailure());
    } catch (_) {
      emit(LocationsFetchFailure());
    }
  }

}
