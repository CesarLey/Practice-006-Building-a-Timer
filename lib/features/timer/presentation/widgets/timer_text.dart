import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiritochi/core/services/audio_service.dart';
import 'package:kiritochi/features/timer/application/timer_bloc.dart';

/// The TimerText class is a StatelessWidget in Dart that displays a timer in minutes and seconds
/// format. When in TimerInitial state, it can be tapped to set a custom duration.
class TimerText extends StatelessWidget {
  const TimerText({super.key});

  Future<void> _showDurationDialog(BuildContext context, int currentDuration) async {
    final result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _DurationDialog(currentDuration: currentDuration),
    );

    if (result != null && context.mounted) {
      context.read<TimerBloc>().add(TimerReset(customDuration: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final duration = state.duration;
        final initialDuration = state.initialDuration;
        final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
        final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
        
        final progress = initialDuration > 0 ? duration / initialDuration : 0.0;
        
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final isLandscape = screenWidth > screenHeight;
        final circleSize = isLandscape ? screenHeight * 0.35 : 250.0;
        
        final textWidget = Text(
          '$minutesStr:$secondsStr',
          style: Theme.of(context).textTheme.headlineLarge,
        );

        final progressWidget = SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: circleSize,
                height: circleSize,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              textWidget,
            ],
          ),
        );

        if (state is TimerInitial) {
          return InkWell(
            onTap: () => _showDurationDialog(context, duration),
            borderRadius: BorderRadius.circular(circleSize / 2),
            child: progressWidget,
          );
        }

        return progressWidget;
      },
    );
  }
}

/// Stateful dialog widget for setting timer duration
class _DurationDialog extends StatefulWidget {
  const _DurationDialog({required this.currentDuration});

  final int currentDuration;

  @override
  State<_DurationDialog> createState() => _DurationDialogState();
}

class _DurationDialogState extends State<_DurationDialog> {
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;
  final _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController(
      text: ((widget.currentDuration / 60) % 60).floor().toString(),
    );
    _secondsController = TextEditingController(
      text: (widget.currentDuration % 60).floor().toString(),
    );
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _onAccept() {
    _audioService.playClick();
    
    final minutesText = _minutesController.text.trim();
    final secondsText = _secondsController.text.trim();
    
    // Handle empty strings as 0
    final minutes = minutesText.isEmpty ? 0 : (int.tryParse(minutesText) ?? 0);
    final seconds = secondsText.isEmpty ? 0 : (int.tryParse(secondsText) ?? 0);
    
    final totalSeconds = (minutes * 60) + seconds;
    
    if (totalSeconds > 0) {
      Navigator.of(context).pop(totalSeconds);
    } else {
      // Show error if total is 0
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La duración debe ser mayor a 0 segundos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onCancel() {
    _audioService.playClick();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Establecer duración'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Minutos',
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _secondsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Segundos',
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _onAccept,
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
