import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/screens/coming_soon.dart';
import 'package:orison/src/screens/completed_surveys.dart';
import 'package:orison/src/screens/index.dart';
import 'package:orison/src/screens/new_surveys.dart';
import 'package:orison/src/screens/processing_surveys.dart';
import 'package:orison/src/screens/profile.dart';
import 'package:orison/src/screens/survey_questionnaire.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget _child;
    switch (_currentTabIndex) {
      case 0:
        _child = IndexScreen();
        break;
      case 1:
        _child = NewSurveysScreen();
        break;
      case 2:
        _child = CompletedSurveysScreen();
        break;
      case 3:
        _child = ProfileScreen();
        break;
    }
    return WillPopScope(
      onWillPop: () async {
        if (_currentTabIndex != 0) {
          _onTap(0);
          return Future<bool>.value(false);
        } else {
          bool res = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Close Application?'),
                content: Text('Are you sure want to close the application?'),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: AppConfig.primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(true);
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
          // print(res);
          if (res)
            return Future<bool>.value(true);
          else
            return Future<bool>.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: AppConfig.white,
        body: BlocListener<AppNavigatorCubit, AppNavigatorState>(
          listener: (BuildContext context, state) {
            if (state is AppNavigatorHome) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  state.route, (Route<dynamic> route) => false);
            }
            if (state is AppNavigatorNewSurveyFragment) {
              _onTap(1);
            }
            if (state is AppNavigatorCompletedSurveyFragment) {
              _onTap(2);
            }
            if (state is AppNavigatorProfileFragment) {
              _onTap(3);
            }
            if (state is AppNavigatorSurveyStart) {
              Navigator.of(context)
                  .pushNamed(state.route, arguments: state.surveyResponse);
            }
            if (state is AppNavigatorSurveyQuestionnaire) {
              Navigator.of(context)
                  .pushNamed(state.route, arguments: state.surveyResponse);
            }
            if (state is AppNavigatorSurveySubmit) {
              Navigator.of(context)
                  .pushNamed(state.route, arguments: state.surveyResponse);
            }
            if (state is AppNavigatorSurveyProcessing) {
              Navigator.of(context).pushNamed(state.route);
            }
          },
          child: SafeArea(
            child: _child,
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedFontSize: 13.0,
      unselectedFontSize: 13.0,
      backgroundColor: AppConfig.scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppConfig.bottomNavigationSelectedColor,
      unselectedItemColor: AppConfig.bottomNavigationUnSelectedColor,
      items: [
        _bottomNavigationBarItem(
            svgImagePath: 'assets/images/home.svg',
            label: 'Home',
            selected: _currentTabIndex == 0),
        _bottomNavigationBarItem(
            svgImagePath: 'assets/images/new_survey.svg',
            label: 'New Audit',
            selected: _currentTabIndex == 1),
        _bottomNavigationBarItem(
            svgImagePath: 'assets/images/completed_survey.svg',
            label: 'Completed',
            selected: _currentTabIndex == 2),
        _bottomNavigationBarItem(
            svgImagePath: 'assets/images/profile.svg',
            label: 'Profile',
            selected: _currentTabIndex == 3),
      ],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: _onTap,
      currentIndex: _currentTabIndex,
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      {String svgImagePath, String label, bool selected}) {
    return BottomNavigationBarItem(
        icon: Container(
          height: 43.w,
          width: 43.w,
          padding: EdgeInsets.zero,
          child: SvgPicture.asset(
            svgImagePath,
            color: selected
                ? AppConfig.bottomNavigationSelectedColor
                : AppConfig.bottomNavigationUnSelectedColor,
            semanticsLabel: label,
          ),
        ),
        label: label);
  }

  _onTap(int tabIndex) async {
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }
}
