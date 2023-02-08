import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/blocs/survey_cubit.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/screens/forgot_password.dart';
import 'package:orison/src/screens/home.dart';
import 'package:orison/src/screens/login.dart';
import 'package:orison/src/screens/processing_surveys.dart';
import 'package:orison/src/screens/splash.dart';
import 'package:orison/src/screens/survey_questionnaire.dart';
import 'package:orison/src/screens/survey_start.dart';
import 'package:orison/src/screens/survey_submit.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';

class App extends StatelessWidget {
  final AppNavigatorCubit _appNavigatorCubit = AppNavigatorCubit();
  final SurveyCubit _surveyCubit = SurveyCubit();

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      */ /* statusBarColor: AppConfig.primaryColorDark,*/ /*
        statusBarIconBrightness: Brightness.light));*/

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => _appNavigatorCubit,
        ),
        BlocProvider(
          create: (BuildContext context) => _surveyCubit,
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(491, 1064),
        builder: (_, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child,
              );
            },
            title: 'Orison',
            theme: ThemeData(
              scaffoldBackgroundColor: AppConfig.scaffoldBackgroundColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              canvasColor: AppConfig.primaryColor,
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppConfig
                      .primaryColor), // Decoration theme for TextFormField
            ),
            routes: {
              Constants.SPLASH_ROUTE: (context) => SplashScreen(),
              Constants.LOGIN: (context) => LoginScreen(),
              Constants.HOME: (context) => HomeScreen(),
              Constants.FORGOT_PASSWORD: (context) => ForgotPasswordScreen(),
              Constants.SURVEY_PROCESSING: (context) =>
                  ProcessingSurveysScreen(),
              //Constants.SURVEY_SUBMIT: (context) => SurveySubmitScreen(),
            },
            initialRoute: Constants.SPLASH_ROUTE,
            onGenerateRoute: (settings) {
              if (settings.name == SurveyStartScreen.routeName) {
                final SurveyResponse args = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return SurveyStartScreen(
                      surveyResponse: args,
                    );
                  },
                );
              }

              if (settings.name == SurveyQuestionnaire.routeName) {
                final SurveyResponse args = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return SurveyQuestionnaire(
                      surveyResponse: args,
                    );
                  },
                );
              }

              if (settings.name == SurveySubmitScreen.routeName) {
                final SurveyResponse args = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return SurveySubmitScreen(
                      surveyResponse: args,
                    );
                  },
                );
              }

              assert(false, 'Need to implement ${settings.name}');
              return null;
            }),
      ),
    );
  }
}
