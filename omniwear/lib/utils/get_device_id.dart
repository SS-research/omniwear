import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'dart:convert'; // For hashing
import 'package:crypto/crypto.dart'; // For hashing

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';

  if (Platform.isAndroid) {
    // Get Android device info
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? androidId = androidInfo.id; // Unique ID for Android
    deviceId = androidId;
  } else if (Platform.isIOS) {
    // Get iOS device info
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    String? identifierForVendor = iosInfo.identifierForVendor; // Unique ID for iOS
    deviceId = identifierForVendor ?? '';
  }

  // Hash the deviceId for additional security
  var bytes = utf8.encode(deviceId);
  var hash = sha256.convert(bytes);
  return hash.toString(); // This will return a hashed device ID
}
