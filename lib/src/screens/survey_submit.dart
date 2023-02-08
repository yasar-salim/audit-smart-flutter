import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ndialog/ndialog.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/blocs/survey_cubit.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/custom_checkbox.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:orison/src/widgets/survey_item_card.dart';
import 'package:orison/src/widgets/title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:toast/toast.dart';

class SurveySubmitScreen extends StatefulWidget {
  static const String routeName = Constants.SURVEY_SUBMIT;
  final SurveyResponse surveyResponse;

  const SurveySubmitScreen({Key key, this.surveyResponse}) : super(key: key);
  @override
  _SurveySubmitScreenState createState() => _SurveySubmitScreenState();
}

class _SurveySubmitScreenState extends State<SurveySubmitScreen> {
  bool _isAgree = false;
  SurveyCubit _surveyCubit = SurveyCubit();
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener(
          bloc: _surveyCubit,
          listener: (context, state) {
            if (state is SurveySubmitBusy) {
              progressDialog = ProgressDialog(
                context,
                blur: 0,
                dismissable: false,
                dialogTransitionType: DialogTransitionType.Shrink,
                title: Text("Please wait"),
                message: BlocBuilder(
                  bloc: _surveyCubit,
                  builder: (context, state) {
                    int current = 0;
                    int total = 0;
                    if (state is SurveySubmitBusyProgress) {
                      current = state.current;
                      total = state.total;
                    }
                    return Text("Submitting answers($current/$total)...");
                  },
                ),
                onDismiss: () {},
              );
              progressDialog.setLoadingWidget(BlocBuilder(
                bloc: _surveyCubit,
                builder: (context, state) {
                  double progress = 0;
                  int current = 0;
                  int total = 0;
                  if (state is SurveySubmitBusyProgress) {
                    progress =
                        total > 0 ? ((current / total) * 100).toDouble() : 0;
                    current = state.current;
                    total = state.total;
                  }

                  return CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: (current / total),
                    center: new Text(
                        "${((current / total) * 100).isNaN ? 0.0 : ((current / total) * 100).toStringAsFixed(0)}%"),
                    progressColor: AppConfig.primaryColor,
                    backgroundColor: AppConfig.scaffoldBackgroundColor,
                  );
                },
              ));
              progressDialog.show();
            }
            if (state is SurveySubmitSuccess) {
              progressDialog.dismiss();
              _showCompleteDialog();
            }
            if (state is SurveySubmitError) {
              progressDialog.dismiss();
              Toast.show("Some error occurred! Try again.",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
            }
          },
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
                  'Terms and Conditions of the data',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppConfig.hintTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Text(
                  'I hereby declare that the information provided in the audit is true to my knowledge. I agree that the audit was conducted in accordance with the guidelines provided. I also understand that any willful dishonesty or false information will lead to rejection of the audit responses.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppConfig.hintTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: CustomCheckbox(
                  onSelect: (value) {
                    setState(() {
                      _isAgree = value;
                    });
                  },
                  isChecked: _isAgree,
                ),
              ),
              Spacer(),
              BlocBuilder(
                bloc: _surveyCubit,
                builder: (context, state) {
                  bool buttonEnabled = !(state is SurveyValidationBusy);
                  return RoundAppButton(
                    isBusy: !buttonEnabled,
                    title: "SUBMIT",
                    color: _isAgree
                        ? AppConfig.primaryColor
                        : AppConfig.textFieldFillColor,
                    titleColor:
                        _isAgree ? AppConfig.white : AppConfig.hintTextColor,
                    onPressed: !_isAgree
                        ? null
                        : () {
                            _surveyCubit
                                .submitSurvey(widget.surveyResponse.surveyId);
                          },
                    padding: 25.0,
                    titleFontSize: 18.0,
                  );
                },
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  _showCompleteDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 360,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Success',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppConfig.hintTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Center(
                        child: SvgPicture.asset(
                      'assets/images/success.svg',
                      height: 152,
                      width: 152,
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Your audit has successfully submitted. We Thank you for your participation. ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppConfig.hintTextColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    RoundAppButton(
                      title: "GOTO HOME",
                      onPressed: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<AppNavigatorCubit>(context)
                            .routeToHome();
                      },
                      titleFontSize: 13,
                      padding: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
