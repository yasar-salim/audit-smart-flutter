import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/profile_response.dart';
import 'package:orison/src/models/submit_response.dart';
import 'package:orison/src/resources/repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final Repository _repository = Repository();

  Future<void> checkUserLoggedInStatus() async {
    emit(LoggedInStatusCheckInProgress());
    String token = await _repository.getAccessToken();
    if (token != null && token.isNotEmpty) {
      emit(RegisteredUser());
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        emit(LoginRequired());
      });
    }
  }

  // get profile
  Future<void> getProfile() async {
    emit(ProfileBusy());
    try {
      ProfileResponse response = await _repository.getProfile();
      if (response.status == 1) {
        emit(ProfileSuccess(response));
      } else
        emit(ProfileError());
    } catch (_) {
      // print(_.toString());
      emit(ProfileError());
    }
  }

  // logout
  Future<void> logout() async {
    emit(LogoutBusy());
    try {
      SubmitResponse response = await _repository.logout();
      if (response.status) {
        _repository.logoutUser();
        emit(LogoutSuccess());
      } else
        emit(LogoutError());
    } catch (_) {
      // print(_.toString());
      emit(LogoutError());
    }
  }
}
