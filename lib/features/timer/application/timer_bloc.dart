import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kiritochi/features/timer/domain/repositories/timer_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

/// The TimerBloc class in Dart is responsible for managing timer events and states, utilizing a
/// TimerRepository for functionality like starting, ticking, pausing, and resetting timers.
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required TimerRepository timerRepository})
      : _timerRepository = timerRepository,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerReset>(_onReset);
    on<TimerLapPressed>(_onLapPressed);
  }

  final TimerRepository _timerRepository;
  static const int _duration = 60;
  int _customDuration = _duration;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerTicking(event.duration, event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _timerRepository
        .ticker()
        .listen((ticks) => add(TimerTicked(duration: event.duration - ticks)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerTicking(event.duration, state.initialDuration, state.lapTimes)
          : TimerFinished(state.initialDuration, state.lapTimes),
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerTicking) {
      _tickerSubscription?.pause();
      emit(TimerInitial(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    if (event.customDuration != null) {
      _customDuration = event.customDuration!;
    }
    emit(TimerInitial(_customDuration));
  }

  void _onLapPressed(TimerLapPressed event, Emitter<TimerState> emit) {
    if (state is TimerTicking) {
      final currentState = state as TimerTicking;
      final updatedLaps = List<int>.from(currentState.lapTimes)..add(currentState.duration);
      emit(TimerTicking(currentState.duration, currentState.initialDuration, updatedLaps));
    }
  }
}
