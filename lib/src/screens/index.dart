import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/title.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(
            title: 'Dashboard',
          ),
          Divider(
            thickness: 0.5,
          ),
          DashboardItem(
            svgPath: 'assets/images/dash_completed.svg',
            title: 'Completed Audit',
            onPressed: () {
              BlocProvider.of<AppNavigatorCubit>(context)
                  .routeToCompletedSurveyFragment();
            },
          ),
          DashboardItem(
            svgPath: 'assets/images/dash_processing.svg',
            title: 'Processing Audit',
            onPressed: () {
              BlocProvider.of<AppNavigatorCubit>(context)
                  .routeToSurveyProcessing();
            },
          ),
          DashboardItem(
            svgPath: 'assets/images/dash_new.svg',
            title: 'New Audit',
            onPressed: () {
              BlocProvider.of<AppNavigatorCubit>(context)
                  .routeToNewSurveyFragment();
            },
          ),
          DashboardItem(
            svgPath: 'assets/images/dash_profile.svg',
            title: 'User Profile',
            onPressed: () {
              BlocProvider.of<AppNavigatorCubit>(context)
                  .routeToProfileFragment();
            },
          ),
        ],
      ),
    );
  }
}
