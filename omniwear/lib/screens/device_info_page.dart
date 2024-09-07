import 'dart:async';
import 'dart:developer' as developer;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (dynamic error, dynamic stack) {
    developer.log("Something went wrong!", error: error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeviceInfoPage(),
    );
  }
}

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  bool _isFetching = false;
  bool _dataFetched = false;

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
                      children: _deviceData.keys.map(
                        (String property) {
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
                        },
                      ).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchDeviceInfo() async {
    setState(() {
      _isFetching = true;
    });

    var deviceData = <String, dynamic>{};

    try {
      deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.iOS =>
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        _ => <String, dynamic>{
            'Error:': 'Unsupported platform'
          },
      };
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      _isFetching = false;
      _dataFetched = true;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'model': build.model,
      'version.release': build.version.release,
      // Additional fields can be uncommented if needed
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'systemVersion': data.systemVersion,
      'model': data.model,
      // Additional fields can be uncommented if needed
    };
  }
}
