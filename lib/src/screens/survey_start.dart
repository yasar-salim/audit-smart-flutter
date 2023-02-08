import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:orison/src/widgets/survey_item_card.dart';
import 'package:orison/src/widgets/title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyStartScreen extends StatefulWidget {
  static const String routeName = Constants.SURVEY_START;
  final SurveyResponse surveyResponse;

  const SurveyStartScreen({Key key, this.surveyResponse}) : super(key: key);

  @override
  _SurveyStartScreenState createState() => _SurveyStartScreenState();
}

class _SurveyStartScreenState extends State<SurveyStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(
                title: 'Audit #${widget.surveyResponse.surveyId}',
              ),
              Divider(
                thickness: 0.5,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  'Shall we start the survey',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppConfig.hintTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RoundAppButton(
                title: "START",
                onPressed: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<AppNavigatorCubit>(context)
                      .routeToSurveyQuestionnaire(
                          response: widget.surveyResponse);
                },
                padding: 25.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
