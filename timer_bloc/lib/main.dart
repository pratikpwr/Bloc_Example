import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_bloc/bloc_observer.dart';
import 'package:timer_bloc/data/ticker.dart';
import 'package:timer_bloc/timer/timer_bloc.dart';
import 'package:timer_bloc/views/timer_screen.dart';

void main() {
  Bloc.observer = TimerObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: TimerScreen(),
      ),
    );
  }
}
