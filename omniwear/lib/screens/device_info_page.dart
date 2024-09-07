import 'package:flutter/material.dart';
import 'package:omniwear/services/device_info_service.dart';

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, dynamic> _deviceData = {};
  bool _isFetching = false;

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
            ElevatedButton(
              onPressed: _fetchDeviceInfo,
              child: const Text('Fetch Device Info'),
            ),
            const SizedBox(height: 16),
            _isFetching
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView(
                      children: _deviceData.keys.map((String property) {
                        return Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                property,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  '${_deviceData[property]}',
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _fetchDeviceInfo() async {
    setState(() {
      _isFetching = true;
    });

    final deviceData = await _deviceInfoService.fetchDeviceInfo();

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      _isFetching = false;
    });
  }
}
