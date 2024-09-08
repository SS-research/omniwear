import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omniwear/services/health_data_service.dart';

const defaultHealthFeatures = "STEPS,ACTIVE_ENERGY_BURNED";
const defaultHealthReadingFrequency = 1800;
const defaultHealthReadingInterval = 1800;


class HealthDataPage extends StatefulWidget {
  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  List<HealthDataModel> _healthDataList = [];
  bool _permissionsGranted = false;
  bool _isFetching = false;
  bool _isStreaming = false;

  final HealthDataService _healthDataService = HealthDataService(healthFeatures: defaultHealthFeatures);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
      ),
      body: Column(
        children: <Widget>[
          // First Row - Permission and Fetch Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12)),
                onPressed: _requestPermissions,
                child: const Text('Request Permissions'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12)),
                onPressed: _permissionsGranted ? _fetchHealthData : null,
                child: const Text('Fetch Health Data'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Second Row - Streaming Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12)),
                onPressed: _permissionsGranted && !_isStreaming
                    ? _startStreaming
                    : null,
                child: const Text('Start Streaming Fetch'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12)),
                onPressed: _isStreaming ? _stopStreaming : null,
                child: const Text('Stop Streaming Fetch'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Third Row - Reset Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12)),
                onPressed: _resetPage,
                child: const Text('Reset Page'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Data Display
          _isFetching
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _healthDataList.length,
                    itemBuilder: (context, index) {
                      return _buildHealthDataTile(_healthDataList[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _requestPermissions() async {
    final hasPermissions = await _healthDataService.requestPermissions();
    if (mounted) {
      setState(() {
        _permissionsGranted = hasPermissions;
      });

      if (!hasPermissions) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissions not granted')),
        );
      }
    }
  }

  Future<void> _fetchHealthData() async {
    _stopStreaming();
    if (!mounted) return;
    setState(() {
      _isFetching = true;
    });

    final healthData = await _healthDataService.fetchHealthData(
        intervalInSeconds: 86400); // 86400sec = 1day

    if (mounted) {
      setState(() {
        _healthDataList = healthData;
        _isFetching = false;
      });
    }
  }

  void _startStreaming() {
    _stopStreaming();
    setState(() {
      _isStreaming = true;
    });

    _healthDataService.startStreaming(
      onData: (data) {
        if (mounted) {
          setState(() {
            _healthDataList = data;
          });
        }
      },
      healthReadingFrequency: defaultHealthReadingFrequency,
      healthReadingInterval: defaultHealthReadingInterval,
    );
  }

  void _stopStreaming() {
    setState(() {
      _isStreaming = false;
    });

    _healthDataService.stopStreaming();
  }

  void _resetPage() {
    _stopStreaming();
    setState(() {
      _healthDataList = [];
      _isFetching = false;
      _isStreaming = false;
      _permissionsGranted = false;
    });
  }

  @override
  void dispose() {
    _healthDataService.stopStreaming();
    super.dispose();
  }

  Widget _buildHealthDataTile(HealthDataModel data) {
    return ListTile(
      title: Text(data.category),
      subtitle: Text(data.toString()),
    );
  }
}
