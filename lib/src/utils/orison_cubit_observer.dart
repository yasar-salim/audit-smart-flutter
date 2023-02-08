import 'package:bloc/bloc.dart';

class OrisonCubitObserver extends BlocObserver {
  @override
  void onChange(BlocBase cubit, Change change) {
    // print(change);
    super.onChange(cubit, change);
  }
}
