part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class LoggedInStatusCheckInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class RegisteredUser extends UserState {
  @override
  List<Object> get props => [];
}

class RegistrationRequired extends UserState {
  @override
  List<Object> get props => [];
}

class LoginRequired extends UserState {
  @override
  List<Object> get props => [];
}

// profile


class ProfileBusy extends UserState {
  @override
  List<Object> get props => [];
}
class ProfileError extends UserState {
  @override
  List<Object> get props => [];
}

class ProfileSuccess extends UserState {
  final ProfileResponse response;

  ProfileSuccess(this.response);
  @override
  List<Object> get props => [];
}


// logout

class LogoutBusy extends UserState {
  @override
  List<Object> get props => [];
}
class LogoutError extends UserState {
  @override
  List<Object> get props => [];
}

class LogoutSuccess extends UserState {
  @override
  List<Object> get props => [];
}