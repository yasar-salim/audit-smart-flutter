import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orison/src/blocs/survey_cubit.dart';
import 'package:orison/src/models/survey_response.dart' as s;
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/widgets/custom_radio.dart';
import 'package:orison/src/widgets/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionSingle extends StatefulWidget {
  final s.SurveyResponse survey;
  final s.Questions question;
  final int surveyId;
  final void Function(List, s.AnsOptions) onOptionClick;

  const QuestionSingle(
      {Key key, this.survey, this.question, this.surveyId, this.onOptionClick})
      : super(key: key);

  @override
  _QuestionSingleState createState() => _QuestionSingleState();
}

class _QuestionSingleState extends State<QuestionSingle> {
  var _selected;
  s.AnsOptions _selectedOption;
  List<s.Image> _selectedImage;

  TextEditingController _textEditingControllerComment = TextEditingController();

  SurveyCubit _surveyCubit;

  int total = 0;
  int earned = 0;
  List hideArray = [];

  @override
  void initState() {
    _surveyCubit = BlocProvider.of<SurveyCubit>(context);
    if (widget.question.answers.length > 0) {
      _selected = widget.question.answers.first.id.toString();
      _selectedOption = widget.question.options.firstWhere(
          (element) => element.id == widget.question.answers.first.id);
      hideArray = _selectedOption.skippable;
      _textEditingControllerComment.text =
          widget.question.answers.first.comment;
      _selectedImage = widget.question.answers.first.images;
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
              // print('got points' + state.earned.toString());
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
                  (widget.question.guidelines != null)
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
                      : Text(""),
                  SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.question.options.length,
                    itemBuilder: (context, index) {
                      return CustomRadio(
                        onSelect: (value) {
                          setState(() {
                            _selected = value;
                          });

                          _selectedOption = widget.question.options.firstWhere(
                              (element) => element.id == int.parse(value));
                          widget.onOptionClick(
                              widget.question.options, _selectedOption);
                          _updateAnswer();
                        },
                        selectedValue: _selected,
                        value: widget.question.options[index].id.toString(),
                        textFontSize: 18,
                        text: widget.question.options[index].option,
                      );
                    },
                  ),
                  SizedBox(
                    height: _selectedOption != null ? 15 : 0,
                  ),
                  _selectedOption !=
                          null /*&&
                          _selectedOption.commentRequired == 1*/
                      ? TextField(
                          controller: _textEditingControllerComment,
                          style: TextStyle(color: AppConfig.hintTextColor),
                          minLines: 3,
                          maxLines: 10,
                          onChanged: (s) {
                            // print('called');
                            _updateAnswer();
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
                                  color: _selectedOption.commentRequired == 1
                                      ? Colors.red
                                      : AppConfig.textFieldFillColor,
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: _selectedOption.commentRequired == 1
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
                    height: _selectedOption !=
                            null /*&&
                            _selectedOption.commentRequired == 1*/
                        ? 15
                        : 0,
                  ),
                  _selectedOption !=
                          null /* && _selectedOption.photoRequired == 1*/
                      ? ImagePickerWidget(
                          enableGallery: widget.question.gallery,
                          onSelect: (image) {
                            // print('got image');
                            _selectedImage = image;
                            _updateAnswer();
                          },
                          selectedFile: _selectedImage,
                          isRequired: _selectedOption.photoRequired == 1,
                        )
                      : Container()
                ],
              ),
            );
          },
        ));
  }

  _updateAnswer() async {
    int dec = 0;
    if (widget.question.answers.length > 0)
      dec = widget.question.answers.first.points;
    widget.question.answers.clear();
    widget.question.answers.add(s.Answer(
        id: _selectedOption.id,
        comment: _textEditingControllerComment.text,
        images: _selectedImage,
        points: _selectedOption.points));
    await _surveyCubit.updateQuestion(widget.surveyId, widget.question);
    await _surveyCubit.decrementAndIncrementPoints(
        total, earned, widget.survey);
  }
}
