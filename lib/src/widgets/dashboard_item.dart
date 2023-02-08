import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardItem extends StatelessWidget {
  final String svgPath;
  final String title;
  final Function onPressed;

  const DashboardItem({Key key, this.svgPath, this.title, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          margin: EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 2),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, 3), blurRadius: 30.0, spreadRadius: 1.0)],
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Row(
              children: [
                SvgPicture.asset(
                  '$svgPath',
                  color: AppConfig.primaryColor,
                  width: 80.w,
                  height: 80.w,
                ),
                SizedBox(width: 40,),
                Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppConfig.hintTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          )),
    );
  }
}
