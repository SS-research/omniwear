import 'package:flutter/material.dart';
import 'package:omniwear/config/config_manager.dart';

import 'screens/device_info_page.dart';
import 'screens/health_data_page.dart';
import 'screens/start_session_page.dart';
import 'screens/inertial_data_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigManager.instance.loadConfig('assets/config.yaml');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniWear App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006D7A)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'OmniWear Data Collection'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToPage(context, StartSessionPage()),
              child: const Text('Start Session'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToPage(context, DeviceInfoPage()),
              child: const Text('Device Info'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToPage(context, HealthDataPage()),
              child: const Text('Health Data'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToPage(context, InertialDataPage()),
              child: const Text('Inertial Data'),
            ),
          ],
        ),
      ),
    );
  }
}
