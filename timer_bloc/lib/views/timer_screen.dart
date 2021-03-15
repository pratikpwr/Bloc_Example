import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_bloc/timer/timer_bloc.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [TimerWidget(), TimerActions()],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      alignment: Alignment.center,
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final minuteStr =
              ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
          final secondStr =
              (state.duration % 60).floor().toString().padLeft(2, '0');
          return Text(
            '$minuteStr:$secondStr',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}

class TimerActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previousState, state) {
      return state.runtimeType != previousState.runtimeType;
    }, builder: (context, state) {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _mapStateToActionButtons(
            timerBloc: BlocProvider.of<TimerBloc>(context)),
      ));
    });
  }

  List<Widget> _mapStateToActionButtons({TimerBloc timerBloc}) {
    final TimerState currentState = timerBloc.state;

    if (currentState is TimerInitial) {
      return [
        FloatingActionButton(
          onPressed: () {
            timerBloc.add(TimerStarted(duration: currentState.duration));
          },
          child: Icon(Icons.play_arrow),
        )
      ];
    }
    if (currentState is TimerRunInProgress) {
      return [
        FloatingActionButton(
          onPressed: () {
            timerBloc.add(TimerPaused());
          },
          child: Icon(Icons.pause),
        ),
        FloatingActionButton(
          onPressed: () {
            timerBloc.add(TimerReset());
          },
          child: Icon(Icons.replay),
        )
      ];
    }
    if (currentState is TimerRunPause) {
      return [
        FloatingActionButton(
          onPressed: () {
            timerBloc.add(TimerResumed());
          },
          child: Icon(Icons.play_arrow),
        ),
        FloatingActionButton(
          onPressed: () {
            timerBloc.add(TimerReset());
          },
          child: Icon(Icons.replay),
        )
      ];
    }
    if (currentState is TimerRunComplete) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(TimerReset()),
        ),
      ];
    }
    return [];
  }
}
