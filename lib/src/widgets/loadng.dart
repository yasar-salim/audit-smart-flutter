import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';

class LoaderAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height:MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator(valueColor:
    AlwaysStoppedAnimation<Color>(AppConfig.primaryColor))));
  }
}
