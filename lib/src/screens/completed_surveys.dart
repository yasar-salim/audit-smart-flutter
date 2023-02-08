import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:orison/src/blocs/survey_completed_cubit.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/error_message.dart';
import 'package:orison/src/widgets/loadng.dart';
import 'package:orison/src/widgets/survey_item_card.dart';
import 'package:orison/src/widgets/title.dart';

class CompletedSurveysScreen extends StatefulWidget {
  @override
  _CompletedSurveysScreenState createState() => _CompletedSurveysScreenState();
}

class _CompletedSurveysScreenState extends State<CompletedSurveysScreen> {
  SurveyCompletedCubit _completedCubit;

  @override
  void initState() {
    _completedCubit = SurveyCompletedCubit();
    _completedCubit.getSurveys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(
            title: 'Completed Audit',
          ),
          Divider(
            thickness: 0.5,
          ),
          BlocBuilder(
              bloc: _completedCubit,
              builder: (context, state) {
                if (state is SurveyCompletedSuccess) {
                  if (state.response.surveys.length == 0) {
                    return Center(
                      child: ErrorMessage(
                        title: 'Empty list',
                        message: 'No completed Audit',
                        buttonTitle: '',
                      ),
                    );
                  } else
                    return ListView.builder(
                      itemCount: state.response.surveys.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SurveyItemCard(
                          title: 'Audit  #${state.response.surveys[index].id}',
                          description:
                              'Site ID: ${state.response.surveys[index].siteid}\nAudit Type: ${state.response.surveys[index].name}\n'
                              'Date: ${DateFormat.yMMMMd().format(DateTime.parse(state.response.surveys[index].updatedAt))}',
                          buttonText: null,
                          //survey: state.response[index],
                        );
                      },
                    );
                }
                if (state is SurveyCompletedError) {
                  return Center(
                    child: ErrorMessage(
                      title: 'Failed to fetch completed surveys!',
                      message: 'Please try again',
                      buttonTitle: 'Retry',
                      onButtonPressed: () {
                        _completedCubit.getSurveys();
                      },
                    ),
                  );
                }
                return LoaderAnimation();
              })
        ],
      ),
    );
  }
}
