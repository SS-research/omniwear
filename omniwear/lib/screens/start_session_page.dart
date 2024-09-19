import 'package:flutter/material.dart';
import 'package:omniwear/services/session_service.dart';

class StartSessionPage extends StatefulWidget {
  @override
  _StartSessionPageState createState() => _StartSessionPageState();
}

class _StartSessionPageState extends State<StartSessionPage> {
  final _sessionService = SessionService();
  bool _isSessionActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start session button
            ElevatedButton(
              onPressed: _isSessionActive
                  ? null
                  : () async {
                      final startTimestamp = DateTime.now();
                      final endTimestamp =
                          startTimestamp.add(const Duration(hours: 5));
                      _sessionService.scheduleSession(
                        startTimestamp,
                        endTimestamp,
                      );
                      setState(() {
                        _isSessionActive = true;
                      });
                    },
              style: TextButton.styleFrom(
                foregroundColor: _isSessionActive ? Colors.grey : Colors.blue,
              ),
              child: const Text('Start a new session'),
            ),
            // Stop session button
            ElevatedButton(
              onPressed: !_isSessionActive
                  ? null
                  : () async {
                      final endTimestamp = DateTime.now();
                      _sessionService.stopSession(endTimestamp);
                      setState(() {
                        _isSessionActive = false;
                      });
                    },
              style: TextButton.styleFrom(
                foregroundColor: !_isSessionActive ? Colors.grey : Colors.blue,
              ),
              child: const Text('Stop session'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    final endTimestamp = DateTime.now();
    _sessionService.stopSession(endTimestamp);
    setState(() {
      _isSessionActive = false;
    });
    super.dispose();
  }
}
