import 'dart:async';
import 'dart:developer';

import 'package:omniwear/db/entities/partecipant.dart';
import 'package:omniwear/db/entities/session.dart';
import 'package:omniwear/db/entities/ts_health.dart';
import 'package:omniwear/db/entities/ts_inertial.dart';
import 'package:omniwear/services/device_info_service.dart';
import 'package:omniwear/services/health_data_service.dart';
import 'package:omniwear/services/inertial_data_service.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  final _deviceInfoService = DeviceInfoService();
  final _inertialDataService = InertialDataService();
  final _healthDataService = HealthDataService();
  final _partecipantRepository = Partecipant.getRepository();
  final _sessionRepository = Session.getRepository();
  final _tsHealthRepository = TSHealth.getRepository();
  final _tsInertialRepository = TSInertial.getRepository();
  late String _partecipantID;
  late String _sessionID;
  late Session _session;

  Future<void> scheduleSession(
      DateTime startTimestamp, DateTime endTimestamp) async {
    if (startTimestamp.isAfter(endTimestamp)) {
      throw ArgumentError('Start time must be before end time.');
    }

    log("Scheduling a new session...");
    const uuid = Uuid();
    final partecipants = await _partecipantRepository.fetchAll();
    Partecipant partecipant;
    if (partecipants.isEmpty) {
      partecipant = Partecipant(partecipantID: uuid.v4());
      await _partecipantRepository.insert(partecipant);
    } else {
      partecipant = partecipants[0];
    }
    _partecipantID = partecipant.partecipantID;
    _sessionID = uuid.v4();

    final deviceInfoModel = await _deviceInfoService.fetchDeviceInfo();

    _session = Session(
        sessionID: _sessionID,
        partecipantID: _partecipantID,
        startTimestamp: startTimestamp.toIso8601String(),
        endTimestamp: endTimestamp.toIso8601String(),
        smartphoneModel: deviceInfoModel.smartphoneModel,
        smartphoneOsVersion: deviceInfoModel.smartphoneOsVersion);

    _sessionRepository.insert(_session);

    await _healthDataService.requestPermissions();

    final startDuration = startTimestamp.difference(DateTime.now());
    Timer(startDuration, () {
      log("Starting a new session...");
      _healthDataService.startStreaming(onData: (healthDataModels) {
        for (var healthDataModel in healthDataModels) {
          _tsHealthRepository.insert(TSHealth(
            tsHealthId: uuid.v4(),
            sessionId: _sessionID,
            startTimestamp: healthDataModel.startTimestamp.toIso8601String(),
            endTimestamp: healthDataModel.endTimestamp.toIso8601String(),
            category: healthDataModel.category,
            unit: healthDataModel.unit,
            value: healthDataModel.value.toString(),
          ));
        }
      });
      _inertialDataService.startCollecting((inertialDataModel) {
        _tsInertialRepository.insert(TSInertial(
          tsInertialId: uuid.v4(),
          sessionId: _sessionID,
          timestamp: inertialDataModel.timestamp.toIso8601String(),
          smartphoneAccelerometerTimestamp: inertialDataModel
              .smartphoneAccelerometerTimestamp
              ?.toIso8601String(),
          smartphoneAccelerometerX: inertialDataModel.smartphoneAccelerometerX,
          smartphoneAccelerometerY: inertialDataModel.smartphoneAccelerometerY,
          smartphoneAccelerometerZ: inertialDataModel.smartphoneAccelerometerZ,
          smartphoneGyroscopeTimestamp:
              inertialDataModel.smartphoneGyroscopeTimestamp?.toIso8601String(),
          smartphoneGyroscopeX: inertialDataModel.smartphoneGyroscopeX,
          smartphoneGyroscopeY: inertialDataModel.smartphoneGyroscopeY,
          smartphoneGyroscopeZ: inertialDataModel.smartphoneGyroscopeZ,
          smartphoneMagnometerTimestamp: inertialDataModel
              .smartphoneMagnometerTimestamp
              ?.toIso8601String(),
          smartphoneMagnometerX: inertialDataModel.smartphoneMagnometerX,
          smartphoneMagnometerY: inertialDataModel.smartphoneMagnometerY,
          smartphoneMagnometerZ: inertialDataModel.smartphoneMagnometerZ,
        ));
      }, (sensorName) {
        log("Error for sensor: $sensorName");
      });
    });

    final stopDuration = endTimestamp.difference(DateTime.now());
    Timer(stopDuration, () {
      log("Stopping the session...");
      _healthDataService.stopStreaming();
      _inertialDataService.stopCollecting();
    });
  }

  Future<void> stopSession(DateTime endTimestamp) async {
    log("Stopping the session...");
        _healthDataService.stopStreaming();
    _inertialDataService.stopCollecting();
    _session = _session.copyWith(endTimestamp: endTimestamp.toIso8601String());
    _sessionRepository.update(_sessionID, _session);
  }
}
