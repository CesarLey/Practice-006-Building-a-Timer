import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiritochi/core/services/audio_service.dart';
import 'package:kiritochi/features/timer/application/timer_bloc.dart';

/// The `ActionsButtons` class in Dart is a stateless widget that displays different action buttons
/// based on the state of a `TimerBloc` in a Flutter application.
class ActionsButtons extends StatelessWidget {
  ActionsButtons({super.key});

  final _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() => [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () {
                    _audioService.playClick();
                    context.read<TimerBloc>().add(
                      TimerStarted(duration: state.duration),
                    );
                  },
                ),
              ],
              TimerTicking() => [
                FloatingActionButton(
                  child: const Icon(Icons.pause),
                  onPressed: () {
                    _audioService.playClick();
                    context.read<TimerBloc>().add(const TimerPaused());
                  },
                ),
                FloatingActionButton(
                  child: const Icon(Icons.flag),
                  onPressed: () {
                    _audioService.playClick();
                    context.read<TimerBloc>().add(const TimerLapPressed());
                  },
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () {
                    _audioService.playClick();
                    context.read<TimerBloc>().add(const TimerReset());
                  },
                ),
              ],
              TimerFinished() => [
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () {
                    _audioService.playClick();
                    context.read<TimerBloc>().add(const TimerReset());
                  },
                ),
              ],
            },
          ],
        );
      },
    );
  }
}
