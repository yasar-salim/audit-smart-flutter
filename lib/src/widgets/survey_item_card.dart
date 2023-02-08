import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final SurveyResponse survey;
  final ValueChanged<int> onDelete;

  const SurveyItemCard(
      {Key key,
      this.title,
      this.description,
      this.buttonText,
      this.survey,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonText != null
          ? () {
              BlocProvider.of<AppNavigatorCubit>(context)
                  .routeToSurveyQuestionnaire(response: survey);
            }
          : null,
      child: Container(
          margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 2),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 3),
                blurRadius: 30.0,
                spreadRadius: 1.0)
          ], borderRadius: BorderRadius.circular(15.0), color: Colors.white),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title',
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
                  '$description',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppConfig.hintTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 15,
                ),
                buttonText != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: RoundAppButton(
                              title: "DELETE",
                              height: 38.0.h,
                              titleFontSize: 14.0,
                              padding: 5,
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete?'),
                                      content: Text(
                                          'Are you sure want to delete this survey?'),
                                      actions: <Widget>[
                                        new TextButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop(
                                                    false); // dismisses only the dialog and returns false
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                color: AppConfig.primaryColor),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            onDelete(survey.surveyId);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop(
                                                    true); // dismisses only the dialog and returns true
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                color: AppConfig.primaryColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: RoundAppButton(
                              title: "$buttonText",
                              height: 38.0.h,
                              titleFontSize: 14.0,
                              padding: 5,
                              onPressed: () {
                                BlocProvider.of<AppNavigatorCubit>(context)
                                    .routeToSurveyQuestionnaire(
                                        response: survey);
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )),
    );
  }
}
