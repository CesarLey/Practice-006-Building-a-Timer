import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiritochi/features/timer/application/timer_bloc.dart';

/// The LapsList widget displays a list of recorded lap times from the timer.
class LapsList extends StatelessWidget {
  const LapsList({super.key});

  String _formatDuration(int seconds) {
    final minutes = ((seconds / 60) % 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final lapTimes = context.select((TimerBloc bloc) => bloc.state.lapTimes);

    if (lapTimes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Responsive height based on screen orientation
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth > screenHeight;
    final maxHeight = isLandscape ? screenHeight * 0.25 : 200.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vueltas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: lapTimes.length,
              itemBuilder: (context, index) {
                final lapNumber = lapTimes.length - index;
                final lapTime = lapTimes[lapTimes.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vuelta $lapNumber',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        _formatDuration(lapTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
