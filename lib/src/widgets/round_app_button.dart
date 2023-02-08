import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';
import 'raised_app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundAppButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;
  final BoxShadow shadowTheme;
  final Color color;
  final Color titleColor;
  final double padding;
  final double height;
  final bool isBusy;
  final double titleFontSize;

  const RoundAppButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.shadowTheme = AppConfig.boxShadowTheme,
    this.color = AppConfig.primaryButtonColor,
    this.titleColor = AppConfig.white,
    this.padding = 16.0,
    this.height = 48.0,
    this.titleFontSize = 14.0,
    this.subtitle = "",
    this.isBusy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: RaisedAppButton(
        color: color,
        shadow: false,
        height: height,
        shadowTheme: shadowTheme,
        onPressed: onPressed,
        child: Stack(
          children: [
            Center(
              child: isBusy
                  ? SizedBox(
                height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppConfig.white),
                      ),
                  )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          title,
                          style: TextStyle(
                            fontSize: titleFontSize.sp,
                            color: titleColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      subtitle.isNotEmpty ? Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppConfig.buttonSubtitleTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ) : Container(),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
