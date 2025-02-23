import 'package:flutter/material.dart';
import 'package:omniwear/services/device_info_service.dart';

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  DeviceInfoModel? _deviceData;
  bool _isFetching = true; // Start as true to show loading indicator initially
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDeviceInfo();
  }

  Future<void> _fetchDeviceInfo() async {
    try {
      final deviceData = await _deviceInfoService.fetchDeviceInfo();
      if (!mounted) return;
      setState(() {
        _deviceData = deviceData;
        _isFetching = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Device information not available';
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _isFetching
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : Expanded(child: buildDeviceInfo(_deviceData)),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceInfo(DeviceInfoModel? deviceData) {
    if (deviceData == null) {
      return const Center(
        child: Text(
          'Device info not available',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Model:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(deviceData.smartphoneModel),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'OS Version:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(deviceData.smartphoneOsVersion),
            ],
          ),
        ),
      ],
    );
  }
}
