import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';

class ComingSoonScreen extends StatefulWidget {
  @override
  _ComingSoonScreenState createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Coming soon",style: TextStyle(color: AppConfig.hintTextColor,fontSize: 26),),
    );
  }
}
