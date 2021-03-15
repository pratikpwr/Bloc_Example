import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:timer_bloc/data/ticker.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

  // we need to define the dependency on our Ticker.
  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker,
        super(TimerInitial(_duration));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  // We also need to override the close method on our TimerBloc so that we can
  // cancel the _tickerSubscription when the TimerBloc is closed.
  @override
  Future<Function> close() {
    _tickerSubscription.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted started) async* {
    // If the TimerBloc receives a TimerStarted event, it pushes a
    // TimerRunInProgress state with the start duration.
    yield TimerRunInProgress(started.duration);

    // if there was already an open _tickerSubscription we need to cancel it
    // to deallocate the memory.
    _tickerSubscription?.cancel();

    // we listen to the _ticker.tick stream and on every tick we add a
    // TimerTicked event with the remaining duration.
    _tickerSubscription =
        _ticker.tick(ticks: started.duration).listen((duration) {
      return add(TimerTicked(duration: _duration));
    });
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked ticked) async* {
    yield ticked.duration > 0
        ? TimerRunInProgress(ticked.duration)
        : TimerRunComplete(ticked.duration);
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused paused) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resumed) async* {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubscription?.cancel();
    yield TimerInitial(_duration);
  }
}
