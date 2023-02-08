import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/survey_cubit.dart';
import 'package:orison/src/models/survey_response.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/custom_checkbox.dart';
import 'package:orison/src/widgets/image_picker.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionMultiple extends StatefulWidget {
  final SurveyResponse survey;
  final Questions question;
  final int surveyId;
  final void Function(List, List<AnsOptions>) onOptionClick;

  const QuestionMultiple(
      {Key key, this.survey, this.question, this.surveyId, this.onOptionClick})
      : super(key: key);

  @override
  _QuestionMultipleState createState() => _QuestionMultipleState();
}

class _QuestionMultipleState extends State<QuestionMultiple> {
  var _selected;
  List<AnsOptions> _selectedOptions = [];

  List<TextEditingController> _textEditingControllers = [];

  SurveyCubit _surveyCubit;
  int total = 0;
  int earned = 0;

  @override
  void initState() {
    _surveyCubit = BlocProvider.of<SurveyCubit>(context);
    for (var option in widget.question.options) {
      _textEditingControllers.add(new TextEditingController());
    }

    if (widget.question.answers.length > 0) {
      for (var answer in widget.question.answers) {
        int index = widget.question.options
            .indexWhere((element) => element.id == answer.id);
        _selectedOptions.add(widget.question.options[index]);
        _textEditingControllers[index].text = answer.comment;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 2),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 3),
              blurRadius: 30.0,
              spreadRadius: 1.0)
        ], borderRadius: BorderRadius.circular(15.0), color: Colors.white),
        child: BlocBuilder(
          bloc: _surveyCubit,
          builder: (context, state) {
            if (state is SurveyPointsUpdated) {
              // print('got points');
              total = state.total;
              earned = state.earned;
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.question.questionId}: ${widget.question.question}',
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
                  widget.question.guidelines != null
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              '${widget.question.guidelines}'),
                                        ));
                              },
                              child: Icon(
                                Icons.info_outline,
                                color: AppConfig.hintTextColor,
                              )),
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.question.options.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          CustomCheckbox(
                            onSelect: (value) {
                              setState(() {
                                _selected = value;
                              });
                              if (value) {
                                _selectedOptions?.removeWhere((element) =>
                                    element.id ==
                                    widget.question.options[index].id);
                                _selectedOptions.add(widget.question.options
                                    .firstWhere((element) =>
                                        element.id ==
                                        widget.question.options[index].id));

                                // update answer
                                widget.question.answers?.removeWhere(
                                  (element) =>
                                      element.id ==
                                      widget.question.options[index].id,
                                );
                                widget.question.answers.add(Answer(
                                    id: widget.question.options[index].id,
                                    comment:
                                        _textEditingControllers[index].text,
                                    images: null,
                                    points:
                                        widget.question.options[index].points));
                                _surveyCubit.incrementPoints(total, earned,
                                    widget.question.options[index].points);
                              } else {
                                _selectedOptions.removeWhere((element) =>
                                    element.id ==
                                    widget.question.options[index].id);
                                widget.question.answers.removeWhere((element) =>
                                    element.id ==
                                    widget.question.options[index].id);
                                _surveyCubit.decrementPoints(total, earned,
                                    widget.question.options[index].points);
                              }
                              widget.onOptionClick(
                                  widget.question.options, _selectedOptions);
                              _saveQuestion();
                              // print(_selectedOptions.length);
                              // _selectedOptions.forEach(
                              //     (n) => print("ID" + n.id.toString()));
                            },
                            isChecked: (_selectedOptions.singleWhere(
                                    (it) =>
                                        it.id ==
                                        widget.question.options[index].id,
                                    orElse: () => null)) !=
                                null,
                            textFontSize: 18,
                            text: widget.question.options[index].option,
                          ),
                          _selectedOptions.firstWhere(
                                      (element) =>
                                          element.id ==
                                          widget.question.options[index].id,
                                      orElse: () => null) !=
                                  null /*&&
                              widget.question.options[index]
                                      .commentRequired ==
                                  1*/
                              ? TextField(
                                  controller: _textEditingControllers[index],
                                  style:
                                      TextStyle(color: AppConfig.hintTextColor),
                                  minLines: 3,
                                  maxLines: 10,
                                  onChanged: (s) {
                                    // update answer
                                    widget.question.answers
                                            .firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget.question
                                                        .options[index].id)
                                            .comment =
                                        _textEditingControllers[index].text;
                                    // widget.question.answers.add(Answer(id: widget.question.options[index].id,comment: _textEditingControllers[index].text,image: null));
                                    _saveQuestion();
                                  },
                                  decoration: new InputDecoration(
                                    hintText: 'Comments',
                                    hintStyle: TextStyle(
                                        color: AppConfig.hintTextColor,
                                        fontSize: 14.sp),
                                    filled: true,
                                    fillColor: AppConfig.textFieldFillColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _selectedOptions
                                                      .firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              widget
                                                                  .question
                                                                  .options[
                                                                      index]
                                                                  .id,
                                                          orElse: () => null)
                                                      .commentRequired ==
                                                  1
                                              ? Colors.red
                                              : AppConfig.textFieldFillColor,
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _selectedOptions
                                                      .firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              widget
                                                                  .question
                                                                  .options[
                                                                      index]
                                                                  .id,
                                                          orElse: () => null)
                                                      .commentRequired ==
                                                  1
                                              ? Colors.red
                                              : AppConfig.textFieldFillColor,
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: _selectedOptions.firstWhere(
                                        (element) =>
                                            element.id ==
                                            widget.question.options[index].id,
                                        orElse: () => null) !=
                                    null /*&&
                                widget.question.options[index]
                                        .commentRequired ==
                                    1*/
                                ? 15
                                : 0,
                          ),
                          _selectedOptions.firstWhere(
                                      (element) =>
                                          element.id ==
                                          widget.question.options[index].id,
                                      orElse: () => null) !=
                                  null /*&&
                              widget.question.options[index].photoRequired ==
                                  1*/
                              ? ImagePickerWidget(
                                  enableGallery: widget.question.gallery,
                                  onSelect: (image) {
                                    // print(image);
                                    widget.question.answers
                                        .firstWhere((element) =>
                                            element.id ==
                                            widget.question.options[index].id)
                                        .images = image;
                                    _saveQuestion();
                                  },
                                  selectedFile: widget.question.answers
                                      .firstWhere(
                                          (element) =>
                                              element.id ==
                                              widget.question.options[index].id,
                                          orElse: () => null)
                                      ?.images,
                                  isRequired: _selectedOptions
                                          .firstWhere(
                                              (element) =>
                                                  element.id ==
                                                  widget.question.options[index]
                                                      .id,
                                              orElse: () => null)
                                          .photoRequired ==
                                      1,
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        ));
  }

  _saveQuestion() async {
    _surveyCubit.updateQuestion(widget.surveyId, widget.question);
    await _surveyCubit.decrementAndIncrementPoints(
        total, earned, widget.survey);
  }
}
