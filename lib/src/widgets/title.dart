import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orison/src/blocs/survey_cubit.dart';

class PageTitle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showPop;
  final bool showPoints;
  final String score;
  final double fontSize;

  const PageTitle(
      {Key key,
      this.title,
      this.showPop = false,
      this.subtitle,
      this.showPoints = false,
      this.score,
      this.fontSize = 40})
      : super(key: key);

  @override
  _PageTitleState createState() => _PageTitleState();
}

class _PageTitleState extends State<PageTitle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
      child: Row(
        children: [
          widget.showPop
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                          child: Icon(
                        Icons.arrow_back_ios,
                        color: const Color(0xff707070),
                      ))))
              : Container(),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.title}',
                  style: TextStyle(
                    fontSize: widget.fontSize.sp,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
                widget.subtitle != null
                    ? Text(
                        '${widget.subtitle}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xff707070),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
          ),
          Spacer(),
          widget.showPoints
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xff707070),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '${widget.score}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xff707070),
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                )
              : SizedBox(
                  width: 0,
                )
        ],
      ),
    );
  }
}
