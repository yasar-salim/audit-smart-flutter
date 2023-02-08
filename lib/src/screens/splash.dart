import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/blocs/user_cubit.dart';
import 'package:orison/src/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final UserCubit _userCubit = UserCubit();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userCubit.checkUserLoggedInStatus();
    return MultiBlocListener(
      listeners: [
        BlocListener<AppNavigatorCubit, AppNavigatorState>(
          listener: (BuildContext context, state) {
            if (state is AppNavigatorHome){
              Navigator.of(context).pushNamedAndRemoveUntil(
                  state.route, (Route<dynamic> route) => false);
            }
            if (state is AppNavigatorAuthorization) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  state.route, (Route<dynamic> route) => false);
            }
          },
        ),
        BlocListener(
          bloc: _userCubit,
          listener: (BuildContext context, state) {
            if (state is RegisteredUser) {
              BlocProvider.of<AppNavigatorCubit>(context).routeToHome();
            }
            if (state is LoginRequired) {
              BlocProvider.of<AppNavigatorCubit>(context).routeToAuthorization();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: new Color(0xff622F74),
                gradient: LinearGradient(
                  colors: [const Color(0xffF15A27),const Color(0xffF16F27), const Color(0xffF18827),const Color(0xffF19727) ,const Color(0xffF1A027)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1,0.35, 0.6,0.75, 0.99],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(alignment: Alignment.center,child: Image.asset('assets/images/logo.png',width: MediaQuery.of(context).size.width*0.5,))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
