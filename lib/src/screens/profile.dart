import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/user_cubit.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/error_message.dart';
import 'package:orison/src/widgets/loadng.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:orison/src/widgets/survey_item_card.dart';
import 'package:orison/src/widgets/title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserCubit _userCubit;

  @override
  void initState() {
    _userCubit = UserCubit();
    _userCubit.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener(
        bloc: _userCubit,
        listener: (BuildContext context, state) {
          if (state is LogoutError) {
            Toast.show("Some error occurred! Try again.",
                duration: Toast.lengthLong, gravity: Toast.bottom);
          }
          if (state is LogoutSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                Constants.LOGIN, (Route<dynamic> route) => false);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitle(
              title: 'Profile',
            ),
            Divider(
              thickness: 0.5,
            ),
            BlocBuilder(
                bloc: _userCubit,
                buildWhen: (previous, current) =>
                    current is ProfileBusy ||
                    current is ProfileError ||
                    current is ProfileSuccess,
                builder: (context, state) {
                  if (state is ProfileSuccess) {
                    if (state.response.status != 1) {
                      return Center(
                        child: ErrorMessage(
                          title: 'Something went wrong.',
                          message: 'Try again',
                          buttonTitle: 'Retry',
                          onButtonPressed: () {
                            _userCubit.getProfile();
                          },
                        ),
                      );
                    } else
                      return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              left: 25, right: 25, top: 20, bottom: 2),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    offset: Offset(0, 3),
                                    blurRadius: 30.0,
                                    spreadRadius: 1.0)
                              ],
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${state.response.data.name}',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppConfig.hintTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${state.response.data.email}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppConfig.hintTextColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ));
                  }
                  if (state is ProfileError) {
                    return Center(
                      child: ErrorMessage(
                        title: 'Something went wrong.',
                        message: 'Please try again',
                        buttonTitle: 'Retry',
                        onButtonPressed: () {
                          _userCubit.getProfile();
                        },
                      ),
                    );
                  }
                  return LoaderAnimation();
                }),
            SizedBox(
              height: 20,
            ),
            BlocBuilder(
              bloc: _userCubit,
              builder: (context, state) {
                bool buttonEnabled = !(state is LogoutBusy);
                return RoundAppButton(
                  title: "LOGOUT",
                  isBusy: !buttonEnabled,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Logout?'),
                          content: Text('Are you sure want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop(
                                    false); // dismisses only the dialog and returns false
                              },
                              child: Text(
                                'No',
                                style: TextStyle(color: AppConfig.primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _userCubit.logout();
                                Navigator.of(context, rootNavigator: true).pop(
                                    true); // dismisses only the dialog and returns true
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(color: AppConfig.primaryColor),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  padding: 25.0,
                );
              },
            )
            /*RoundAppButton(title: "LOGOUT", onPressed: (){

              Navigator.of(context).pushNamedAndRemoveUntil(
                  Constants.LOGIN, (Route<dynamic> route) => false);
            },padding: 25.0,)*/
          ],
        ),
      ),
    );
  }
}
