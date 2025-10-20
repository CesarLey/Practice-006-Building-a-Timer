import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiritochi/features/timer/application/timer_bloc.dart';
import 'package:kiritochi/features/timer/presentation/widgets/actions_buttons.dart';
import 'package:kiritochi/features/timer/presentation/widgets/background.dart';
import 'package:kiritochi/features/timer/presentation/widgets/laps_list.dart';
import 'package:kiritochi/features/timer/presentation/widgets/timer_text.dart';

/// The TimerView class in Dart defines a widget for displaying a timer with associated actions in a
/// responsive layout.
class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxHeight > constraints.maxWidth;
          final verticalPadding = isPortrait
              ? constraints.maxHeight * 0.1
              : constraints.maxHeight * 0.05;
          return Stack(
            children: [
              const Background(),
              _TimerView(verticalPadding: verticalPadding),
            ],
          );
        },
      ),
    );
  }
}

/// The _TimerView class is a StatelessWidget in Dart that displays a TimerText widget with specified
/// vertical padding and ActionButtons below it. It also plays a sound when the timer finishes.
class _TimerView extends StatelessWidget {
  const _TimerView({required this.verticalPadding});

  final double verticalPadding;

  Future<void> _playCompletionSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('audio/timer_complete.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerFinished) {
          _playCompletionSound();
        }
      },
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).padding.top - 
                       kToolbarHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: const Center(child: TimerText()),
                ),
                ActionsButtons(),
                const SizedBox(height: 16),
                const LapsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
