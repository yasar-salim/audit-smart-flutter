import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/blocs/survey_cubit.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/error_message.dart';
import 'package:orison/src/widgets/loadng.dart';
import 'package:orison/src/widgets/question_multiple.dart';
import 'package:orison/src/widgets/question_single.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:orison/src/widgets/title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class SurveyQuestionnaire extends StatefulWidget {
  static const String routeName = Constants.SURVEY_QUESTIONNAIRE;
  final SurveyResponse surveyResponse;

  const SurveyQuestionnaire({Key key, this.surveyResponse}) : super(key: key);

  @override
  _SurveyQuestionnaireState createState() => _SurveyQuestionnaireState();
}

class _SurveyQuestionnaireState extends State<SurveyQuestionnaire> {
  SurveyCubit _surveyCubit;
  SurveyResponse survey;
  AutoScrollController controller;

  ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  bool isBottom = false;

  int total = 0;
  int earned = 0;
  List hideArray = [];
  // List hideArray = [];

  @override
  void initState() {
    _surveyCubit = BlocProvider.of<SurveyCubit>(context);
    _surveyCubit.getSurveyWithQuestions(widget.surveyResponse.surveyId);
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    super.initState();

    _scrollViewController = new ScrollController();
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }

      // top or bottom check
      double maxScroll = controller.position.maxScrollExtent;
      double currentScroll = controller.position.pixels;
      if (maxScroll == currentScroll) {
        setState(() {
          isBottom = true;
        });
      } else {
        if (isBottom)
          setState(() {
            isBottom = false;
          });
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              height: _showAppbar ? 91.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: BlocBuilder(
                bloc: _surveyCubit,
                builder: (context, state) {
                  if (state is SurveyPointsUpdated) {
                    total = state.total;
                    earned = state.earned;
                  }

                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: PageTitle(
                      title: 'Audit #${widget.surveyResponse.surveyId}',
                      fontSize: 26,
                      subtitle:
                          'Site ID: ${widget.surveyResponse.siteId}\nAudit Type: ${widget.surveyResponse.auditTypeName}\nLocation: ${widget.surveyResponse.siteName}',
                      showPoints: true,
                      showPop: _showAppbar ? true : false,
                      // points: earned.toString() + "/" + total.toString(),
                      score: (total > 0)
                          ? ((earned / total) * 100).floor().toString() + " %"
                          : "0 %",
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is UserScrollNotification) {
                    // close keyboard
                    FocusScope.of(context).unfocus();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocListener(
                        bloc: _surveyCubit,
                        listener: (BuildContext context, state) {
                          if (state is SurveyValidationError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  state.message,
                                  style: TextStyle(color: AppConfig.white),
                                ),
                                backgroundColor: AppConfig.primaryColor,
                              ),
                            );
                            // print(state.index);
                            if (state.index != null)
                              controller.scrollToIndex(state.index,
                                  preferPosition: AutoScrollPosition.begin);
                          }

                          if (state is SurveyValidationSuccess) {
                            BlocProvider.of<AppNavigatorCubit>(context)
                                .routeToSurveySubmit(response: state.response);
                          }
                        },
                        child: BlocBuilder(
                            bloc: _surveyCubit,
                            builder: (context, state) {
                              if (state is SurveySuccess) {
                                survey = state.response;
                                _surveyCubit.calculatePoints(state.response);
                              }
                              if (survey != null) {
                                return ListView.builder(
                                  itemCount: survey.questions.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // print(
                                    //     "${survey.questions[index].questionId}" +
                                    //         survey.questions[index].gallery
                                    //             .toString());

                                    // checking for hidden questions start

                                    if (hideArray.contains(
                                        survey.questions[index].questionId)) {
                                      survey.questions[index].visible = false;
                                      survey.questions[index].answers = [];
                                      _surveyCubit.updateQuestion(
                                          survey.surveyId,
                                          survey.questions[index]);
                                    }
                                    // checking for hidden questions ends

                                    if (survey.questions[index].answerType ==
                                        1) {
                                      return Visibility(
                                        visible:
                                            survey.questions[index].visible,
                                        child: AutoScrollTag(
                                            key: ValueKey(index),
                                            controller: controller,
                                            index: index,
                                            child: QuestionSingle(
                                              survey: survey,
                                              question: survey.questions[index],
                                              surveyId: survey.surveyId,
                                              onOptionClick:
                                                  (allOptions, selectedOption) {
                                                if (survey.questions[index]
                                                    .skippable) {
                                                  List allSkippable = survey
                                                      .questions[index].options
                                                      .map((option) =>
                                                          option.skippable)
                                                      .toList()
                                                      .expand(
                                                          (element) => element)
                                                      .toList();

                                                  print(
                                                      'selectedOption.skippable');
                                                  print(
                                                      selectedOption.skippable);

                                                  if (selectedOption
                                                          .skippable.length ==
                                                      0) {
                                                    for (var qId
                                                        in allSkippable) {
                                                      final skipedQuestionIndex =
                                                          survey.questions
                                                              .indexWhere(
                                                                  (question) =>
                                                                      question
                                                                          .questionId ==
                                                                      qId);

                                                      survey
                                                          .questions[
                                                              skipedQuestionIndex]
                                                          .visible = true;
                                                      _surveyCubit.updateQuestion(
                                                          survey.surveyId,
                                                          survey.questions[
                                                              skipedQuestionIndex]);
                                                    }

                                                    hideArray = selectedOption
                                                        .skippable;
                                                    setState(() {});
                                                  } else {
                                                    hideArray = selectedOption
                                                        .skippable;
                                                    setState(() {});
                                                  }

                                                  // print(hideArray);
                                                }
                                              },
                                            )),
                                      );
                                    } else {
                                      return Visibility(
                                        visible:
                                            survey.questions[index].visible,
                                        child: AutoScrollTag(
                                            key: ValueKey(index),
                                            controller: controller,
                                            index: index,
                                            child: QuestionMultiple(
                                                survey: survey,
                                                question:
                                                    survey.questions[index],
                                                surveyId: survey.surveyId,
                                                onOptionClick: (allOptions,
                                                    selectedOptions) {
                                                  if (survey.questions[index]
                                                      .skippable) {
                                                    List allSkippable = survey
                                                        .questions[index]
                                                        .options
                                                        .map((option) =>
                                                            option.skippable)
                                                        .toList()
                                                        .expand((element) =>
                                                            element)
                                                        .toList();

                                                    List
                                                        skippableAsPerSelection =
                                                        selectedOptions
                                                            .map((selectedOption) =>
                                                                selectedOption
                                                                    .skippable)
                                                            .toList()
                                                            .expand((element) =>
                                                                element)
                                                            .toList();

                                                    print(
                                                        'skippableAsPerSelection');
                                                    print(
                                                        skippableAsPerSelection);

                                                    if (skippableAsPerSelection
                                                            .length ==
                                                        0) {
                                                      for (var qId
                                                          in allSkippable) {
                                                        final skipedQuestionIndex =
                                                            survey.questions
                                                                .indexWhere(
                                                                    (question) =>
                                                                        question
                                                                            .questionId ==
                                                                        qId);

                                                        survey
                                                            .questions[
                                                                skipedQuestionIndex]
                                                            .visible = true;
                                                        _surveyCubit.updateQuestion(
                                                            survey.surveyId,
                                                            survey.questions[
                                                                skipedQuestionIndex]);
                                                      }

                                                      hideArray =
                                                          skippableAsPerSelection;
                                                      setState(() {});
                                                    } else {
                                                      hideArray =
                                                          skippableAsPerSelection;
                                                      setState(() {});
                                                    }

                                                    // print(hideArray);
                                                  }
                                                })),
                                      );
                                    }
                                  },
                                );
                              }
                              if (state is SurveyError) {
                                return Center(
                                  child: ErrorMessage(
                                    title: 'Failed to fetch survey!',
                                    message: 'Please try again',
                                    buttonTitle: 'Retry',
                                    onButtonPressed: () {
                                      _surveyCubit.getSurveyWithQuestions(
                                          widget.surveyResponse.surveyId);
                                    },
                                  ),
                                );
                              }
                              return LoaderAnimation();
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder(
                        bloc: _surveyCubit,
                        builder: (context, state) {
                          bool buttonEnabled = !(state is SurveyValidationBusy);

                          return RoundAppButton(
                            isBusy: !buttonEnabled,
                            title: "NEXT",
                            onPressed: () async {
                              _surveyCubit.validateSurvey(
                                  widget.surveyResponse.surveyId);
                            },
                            padding: 25.0,
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConfig.primaryButtonColor,
        onPressed: () {
          if (isBottom)
            controller.animateTo(controller.position.minScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          else
            controller.animateTo(controller.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
        },
        child: Icon(isBottom ? Icons.arrow_upward : Icons.arrow_downward),
      ),
    );
  }
}
