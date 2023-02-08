import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/blocs/login_cubit.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginCubit _loginCubit;
  TextEditingController _textEditingControllerPassword;
  TextEditingController _textEditingControllerEmail;

  bool isObscure = true;

  @override
  void initState() {
    _loginCubit = LoginCubit();
    _textEditingControllerPassword = TextEditingController();
    _textEditingControllerEmail = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingControllerPassword.dispose();
    _textEditingControllerEmail.dispose();
    _loginCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: _loginCubit,
            listener: (BuildContext context, state) {
              if (state is LoginValidationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill all fields properly!'),
                  ),
                );
              }
              if (state is LoginSuccess) {
                _textEditingControllerEmail.clear();
                _textEditingControllerPassword.clear();
                BlocProvider.of<AppNavigatorCubit>(context).routeToHome();
              }
              if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
          ),
          BlocListener<AppNavigatorCubit, AppNavigatorState>(
            listener: (BuildContext context, state) {
              if (state is AppNavigatorHome) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    state.route, (Route<dynamic> route) => false);
              }
            },
          )
        ],
        child: Stack(
          children: [
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: new Color(0xff622F74),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xffF15A27),
                    const Color(0xffF16F27),
                    const Color(0xffF18827),
                    const Color(0xffF19727),
                    const Color(0xffF1A027)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.35, 0.6, 0.75, 0.99],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.width * 0.5,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Container(
                      height: 450,
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50.0),
                              topLeft: Radius.circular(50.0)),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 40.sp,
                              color: const Color(0xff707070),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff707070),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _textEditingControllerEmail,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: AppConfig.hintTextColor
                                        .withOpacity(0.5),
                                    fontSize: 14.sp),
                                hintText: "Your Email",
                                fillColor: AppConfig.textFieldFillColor,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff707070),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _textEditingControllerPassword,
                            obscureText: isObscure,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: AppConfig.hintTextColor
                                        .withOpacity(0.5),
                                    fontSize: 14.sp),
                                hintText: "Your Password",
                                fillColor: AppConfig.textFieldFillColor,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isObscure = !isObscure;
                                      });
                                    },
                                    child: Icon(isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          /*Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Constants.FORGOT_PASSWORD);
                              },
                              child: Text(
                                'Forget Password',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppConfig.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),*/
                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder(
                              bloc: _loginCubit,
                              builder: (context, state) {
                                bool buttonEnabled = !(state is LoginBusy);

                                return RoundAppButton(
                                  isBusy: !buttonEnabled,
                                  title: "LOGIN",
                                  padding:
                                      MediaQuery.of(context).size.width * 0.27,
                                  onPressed: buttonEnabled
                                      ? () {
                                          _loginCubit.validateInputFields(
                                            email: _textEditingControllerEmail
                                                .text
                                                .trim(),
                                            password:
                                                _textEditingControllerPassword
                                                    .text
                                                    .trim(),
                                          );
                                        }
                                      : null,
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
