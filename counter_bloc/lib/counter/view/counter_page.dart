import 'package:counter_bloc/counter/bloc/counter_bloc.dart';
import 'package:counter_bloc/counter/counter.dart';
import 'package:counter_bloc/counter/view/counter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CounterCubit>(
        create: (context) => CounterCubit(),
      ),
      BlocProvider<CounterBloc>(create: (context) => CounterBloc())
    ], child: CounterView());
  }
}
