import 'package:bloc/bloc.dart';

class TimerObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} , $transition');
  }
}
