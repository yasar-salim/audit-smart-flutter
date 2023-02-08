//import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orison/src/app.dart';
import 'package:orison/src/utils/orison_cubit_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = OrisonCubitObserver();
  //runAppSpector();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(App()),
  );
  //runApp(App());
}

/*
void runAppSpector() {
  final config = Config()
    ..iosApiKey = "android_NWY5NGU2MjktN2IyNy00Zjk2LWJiODgtYzQwNDMyNDAwOGU5"
    ..androidApiKey = "android_NWY5NGU2MjktN2IyNy00Zjk2LWJiODgtYzQwNDMyNDAwOGU5";

  // If you don't want to start all monitors you can specify a list of necessary ones
  config.monitors = [Monitors.http, Monitors.logs, Monitors.screenshot];

  AppSpectorPlugin.run(config);
}*/
