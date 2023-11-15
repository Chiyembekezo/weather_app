import 'package:bloc/bloc.dart';

part 'counter_cubit_state.dart';

class CounterCubitCubit extends Cubit<CounterCubitState> {
  CounterCubitCubit() : super(CounterCubitState(counterValue: 0));

  void increment() =>
      emit(CounterCubitState(counterValue: state.counterValue + 1, wasIncremented: true));
  void decrement() =>
      emit(CounterCubitState(counterValue: state.counterValue - 1, wasIncremented: false));
}
