import 'package:bloc_test/bloc_test.dart';
import 'package:counter_bloc/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter Bloc', () {
    CounterBloc counterBloc;

    setUp(() {
      counterBloc = CounterBloc();
    });

    test('initial test is 0', () {
      expect(counterBloc.state, 0);
    });

    blocTest('emit[1] when CounterEvent.increment is added',
        build: () => counterBloc,
        act: (bloc) => bloc.add(CounterEvent.increment),
        expect: [1]);

    blocTest('emit[-1] when CounterEvent.increment is added',
        build: () => counterBloc,
        act: (bloc) => bloc.add(CounterEvent.decrement),
        expect: [-1]);
  });
}
