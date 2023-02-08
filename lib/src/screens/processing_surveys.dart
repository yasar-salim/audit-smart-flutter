import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/survey_processing_cubit.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/error_message.dart';
import 'package:orison/src/widgets/loadng.dart';
import 'package:orison/src/widgets/survey_item_card.dart';
import 'package:orison/src/widgets/title.dart';
import 'package:toast/toast.dart';

class ProcessingSurveysScreen extends StatefulWidget {
  @override
  _ProcessingSurveysScreenState createState() =>
      _ProcessingSurveysScreenState();
}

class _ProcessingSurveysScreenState extends State<ProcessingSurveysScreen> {
  SurveyProcessingCubit _surveyProcessingCubit;

  @override
  void initState() {
    _surveyProcessingCubit = SurveyProcessingCubit();
    _surveyProcessingCubit.getSurveys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener(
          bloc: _surveyProcessingCubit,
          listener: (context, state) {
            ToastContext().init(context);
            if (state is SurveyProcessingDeleteSuccess) {
              Toast.show("Deleted survey.",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
              _surveyProcessingCubit.getSurveys();
            }
            if (state is SurveyProcessingDeleteError) {
              Toast.show("Some error occurred! Try again.",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitle(
                  title: 'Processing Audit',
                  showPop: true,
                ),
                Divider(
                  thickness: 0.5,
                ),
                BlocBuilder(
                    bloc: _surveyProcessingCubit,
                    builder: (context, state) {
                      if (state is SurveyProcessingSuccess) {
                        if (state.response.length == 0) {
                          return Center(
                            child: ErrorMessage(
                              title: 'Empty list',
                              message: 'No surveys in processing',
                              buttonTitle: '',
                            ),
                          );
                        } else
                          return ListView.builder(
                            itemCount: state.response.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SurveyItemCard(
                                title:
                                    'Audit #${state.response[index].surveyId}',
                                description:
                                    'Site ID: ${state.response[index].siteId}\nAudit Type: ${state.response[index].auditTypeName}\nStart Date: ${state.response[index].startDate ?? 'NA'}',
                                buttonText: 'RESUME',
                                survey: state.response[index],
                                onDelete: (id) {
                                  _surveyProcessingCubit.deleteSurvey(id);
                                },
                              );
                            },
                          );
                      }
                      if (state is SurveyProcessingError) {
                        return Center(
                          child: ErrorMessage(
                            title: 'Failed to fetch processing audits!',
                            message: 'Please try again',
                            buttonTitle: 'Retry',
                            onButtonPressed: () {
                              _surveyProcessingCubit.getSurveys();
                            },
                          ),
                        );
                      }
                      return LoaderAnimation();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
