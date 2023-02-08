import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orison/src/models/signin_response.dart';
import 'package:orison/src/models/user.dart';
import 'package:orison/src/resources/repository.dart';
import 'package:orison/src/utils/validator.dart';
import 'package:validators/validators.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final Repository _repository = Repository();

  void validateInputFields({String email, String password}) async {
    emit(LoginBusy());
    if (validateFields(email: email, password: password)) {
      try {
        _repository.saveAccessToken('');
        SignInResponse response = await _repository.signIn(
          email: email,
          password: password,
        );
        if (response.status==1) {
          User user = response.user;
          if (user != null) {
              await _repository.saveUser(user);
              ///Saves user credential, this will keep user session active
              emit(LoginSuccess(user));
          } else {
            emit(LoginError('Login failed!'));
          }
        } else {
          emit(LoginError('Login failed!'));
        }
      } catch (e) {
        emit(LoginError('Failed to connect'));
      }
    } else {
      emit(LoginValidationError());
    }
  }

  bool validateFields({
    String email,
    String password,
  }) {
    if (email == null || email.isEmpty || !isEmail(email))
      return false;
    if (password == null ||
        password.isEmpty /*||
        !Validator.isPasswordCompliant(password)*/) return false;
    return true;
  }
}
