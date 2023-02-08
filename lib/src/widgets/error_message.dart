import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMessage extends StatelessWidget {
  final String title;
  final String message;
  final String buttonTitle;
  final Function onButtonPressed;

  ErrorMessage({
    this.title,
    this.message,
    this.buttonTitle,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$title',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18.sp,
            color: AppConfig.hintTextColor,
            fontWeight: FontWeight.w700,
            height: 1.444,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 15.r,
        ),
        Text(
          '$message',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.sp,
            color: AppConfig.darkFontColor,
            fontWeight: FontWeight.w300,
            height: 1.25,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15.r,
        ),
        onButtonPressed != null
            ? TextButton(
                onPressed: onButtonPressed,
                child: Text(
                  '$buttonTitle',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppConfig.primaryColor,
                  ),
                ))
            : Container(),
      ],
    );
  }
}
