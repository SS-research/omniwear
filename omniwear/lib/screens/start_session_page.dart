import 'package:flutter/material.dart';
import 'package:omniwear/screens/dataset_list_page.dart';
import 'package:omniwear/services/session_service.dart';

class StartSessionPage extends StatefulWidget {
  final DatasetModel datasetModel;

  StartSessionPage({Key? key, required this.datasetModel})
      : super(key: ValueKey(datasetModel.datasetId));

  @override
  _StartSessionPageState createState() => _StartSessionPageState();
}

class _StartSessionPageState extends State<StartSessionPage> {
  late final SessionService _sessionService;
  bool _isSessionActive = false;

  @override
  void initState() {
    super.initState();
    _sessionService = SessionService(datasetModel: widget.datasetModel);
  }

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
    if (_isSessionActive) {
      final endTimestamp = DateTime.now();
      _sessionService.stopSession(endTimestamp);
    }
    super.dispose();
  }
}
