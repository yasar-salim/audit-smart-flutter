part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();
}

class LocationInitial extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationsFetchInProgress extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationsFetchSuccess extends LocationState {
  final List<Location> locations;

  LocationsFetchSuccess(this.locations);

  @override
  List<Object> get props => [locations];
}

class LocationsFetchEmpty extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationsFetchFailure extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationsBusy extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationsSuccess extends LocationState {

  @override
  List<Object> get props => [];
}

class LocationsError extends LocationState {
  @override
  List<Object> get props => [];
}

