import 'package:counter_bloc/counter/bloc/counter_bloc.dart';
import 'package:counter_bloc/counter/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc _bloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, state) {
            return Text(
              '$state',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // context.read<CounterCubit>().increment();
              // context.read<CounterBloc>().add(CounterEvent.increment);
              _bloc.add(CounterEvent.increment);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              // context.read<CounterCubit>().decrement();
              // context.read<CounterBloc>().add(CounterEvent.decrement);
              _bloc.add(CounterEvent.decrement);
            },
            child: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
