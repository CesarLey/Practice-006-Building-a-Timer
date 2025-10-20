part of 'timer_bloc.dart';

/// The `sealed class TimerState extends Equatable` in Dart is defining a base class `TimerState` that
/// is marked as `sealed`. In Dart, a sealed class restricts its subclasses to be defined in the same
/// file. This helps in ensuring that all possible subclasses of `TimerState` are known and handled
/// within the same file.
sealed class TimerState extends Equatable {
  const TimerState(this.duration, this.initialDuration, [this.lapTimes = const []]);
  final int duration;
  final int initialDuration;
  final List<int> lapTimes;

  @override
  List<Object> get props => [duration, initialDuration, lapTimes];
}

/// The `TimerInitial` class represents the initial state of a timer with a specified duration in Dart.
class TimerInitial extends TimerState {
  const TimerInitial(int duration) : super(duration, duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

/// The `TimerTicking` class represents the state of a timer that is currently ticking with a specific
/// duration.
class TimerTicking extends TimerState {
  const TimerTicking(super.duration, super.initialDuration, [super.lapTimes]);

  @override
  String toString() => 'TimerTicking { duration: $duration, initialDuration: $initialDuration, laps: ${lapTimes.length} }';
}

/// The `TimerFinished` class represents a state where the timer has finished.
class TimerFinished extends TimerState {
  const TimerFinished(int initialDuration, [List<int> lapTimes = const []]) : super(0, initialDuration, lapTimes);
}
