import 'dart:async';

import 'package:flutter/material.dart';
import '../../services/analytics_service.dart';
import '../../services/notification_helper.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _focusMinutes = 25;
  int _breakMinutes = 5;
  bool _isRunning = false;
  bool _onBreak = false;
  Timer? _timer;
  Duration _remaining = Duration.zero;
  final AnalyticsService _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _setFocusDuration();
  }

  void _setFocusDuration() {
    _remaining = Duration(minutes: _focusMinutes);
  }

  void _start() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    // schedule a notification for session end
    NotificationHelper.scheduleNotification(id: 1000, title: 'FocusFlow', body: _onBreak ? 'Break ended' : 'Focus session ended', scheduledAt: DateTime.now().add(_remaining));
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _onCompleteSession();
        }
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    NotificationHelper.cancelNotification(1000);
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    NotificationHelper.cancelNotification(1000);
    setState(() {
      _isRunning = false;
      _onBreak = false;
      _setFocusDuration();
    });
  }

  Future<void> _onCompleteSession() async {
    final end = DateTime.now();
    final start = end.subtract(Duration(minutes: _onBreak ? _breakMinutes : _focusMinutes));
    await _analytics.logSession({
      'type': _onBreak ? 'break' : 'focus',
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'duration': (_onBreak ? _breakMinutes : _focusMinutes) * 60,
    });

    // switch to break or back to focus
    if (!_onBreak) {
      // go to break
      setState(() {
        _onBreak = true;
        _remaining = Duration(minutes: _breakMinutes);
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() {
          if (_remaining.inSeconds > 0) {
            _remaining = _remaining - const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            // after break, reset
            _onBreak = false;
            _setFocusDuration();
            _isRunning = false;
          }
        });
      });
    } else {
      // finished break
      setState(() {
        _onBreak = false;
        _setFocusDuration();
        _isRunning = false;
      });
    }
  }

  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(_onBreak ? 'Break' : 'Focus', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 100,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              child: Text(_formatDuration(_remaining), style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _isRunning ? _pause : _start, child: Text(_isRunning ? 'Pause' : 'Start')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Focus (minutes)'),
                      Slider(value: _focusMinutes.toDouble(), min: 5, max: 90, divisions: 17, onChanged: (v) {
                        setState(() {
                          _focusMinutes = v.toInt();
                          if (!_isRunning && !_onBreak) _setFocusDuration();
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Text('$_focusMinutes')),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Break (minutes)'),
                      Slider(value: _breakMinutes.toDouble(), min: 2, max: 30, divisions: 28, onChanged: (v) {
                        setState(() {
                          _breakMinutes = v.toInt();
                          if (!_isRunning && _onBreak) _remaining = Duration(minutes: _breakMinutes);
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Text('$_breakMinutes')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
