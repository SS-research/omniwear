import 'dart:async';
import 'dart:developer';

import 'package:omniwear/api/api_client.dart';
import 'package:omniwear/db/entities/partecipant.dart';
import 'package:omniwear/db/entities/session.dart';
import 'package:omniwear/db/entities/ts_health.dart';
import 'package:omniwear/db/entities/ts_inertial.dart';
import 'package:omniwear/screens/dataset_list_page.dart';
import 'package:omniwear/services/data_transport/data_transport.dart';
import 'package:omniwear/services/device_info_service.dart';
import 'package:omniwear/services/health_data_service.dart';
import 'package:omniwear/services/inertial_data_service.dart';
import 'package:omniwear/utils/get_device_id.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  final _deviceInfoService = DeviceInfoService();
  late InertialDataService _inertialDataService;
  late HealthDataService _healthDataService;
  final _tsHealthRepository = TSHealth.getRepository();
  final _tsInertialRepository = TSInertial.getRepository();
  final _apiClient = ApiClient(); 
  final DataTransport dataTransport;
  late String _partecipantID;
  late String _sessionID;
  late Session _session;
  final DatasetModel datasetModel;

  SessionService({required this.datasetModel, required this.dataTransport});

  Future<void> scheduleSession(
      DateTime startTimestamp, DateTime endTimestamp) async {
    if (startTimestamp.isAfter(endTimestamp)) {
      throw ArgumentError('Start time must be before end time.');
    }

    log("Scheduling a new session...");
    final deviceId = await getDeviceId();
    Partecipant? partecipant;
    dynamic partecipantd = await _apiClient.get('/partecipant/$deviceId');
    if (partecipantd == null) {
      log('Partecipant not registered, registering a new one...');
      partecipant = Partecipant(partecipantID: deviceId);
      await _apiClient.post('/partecipant', partecipant.toMap());
    } else {
      log('Partecipant already registered');
      partecipant = Partecipant.fromMap(partecipantd);
    }
    _partecipantID = partecipant.partecipantID;
    const uuid = Uuid();
    _sessionID = uuid.v4();

    final deviceInfoModel = await _deviceInfoService.fetchDeviceInfo();

    _session = Session(
      sessionID: _sessionID,
      partecipantID: _partecipantID,
      startTimestamp: startTimestamp.toIso8601String(),
      endTimestamp: endTimestamp.toIso8601String(),
      smartphoneModel: deviceInfoModel.smartphoneModel,
      smartphoneOsVersion: deviceInfoModel.smartphoneOsVersion,
      // TODO: fetch from the smartwatch connected to the device when will be enabled
      smartwatchModel: 'Apple Watch Series 7',
      smartwatchOsVersion: 'watchOS 8.0',
    );

    // TODO: create session dto better
    await _apiClient.post('/session',
        {..._session.toMap(), "dataset_id": datasetModel.datasetId});

    _inertialDataService = InertialDataService(
      inertialFeatures: datasetModel.inertialFeatures,
      inertialCollectionDurationSeconds:
          datasetModel.inertialCollectionDurationSeconds,
      inertialCollectionFrequency: datasetModel.inertialCollectionFrequency,
      inertialSleepDurationSeconds: datasetModel.inertialSleepDurationSeconds,
    );

    _healthDataService = HealthDataService(
      healthFeatures: datasetModel.healthFeatures,
      healthReadingFrequency: datasetModel.healthReadingFrequency,
      healthReadingInterval: datasetModel.healthReadingInterval,
    );

    await _healthDataService.requestPermissions();

    dataTransport.connect();

    final startDuration = startTimestamp.difference(DateTime.now());
    Timer(startDuration, () {
      log("Starting a new session...");
      log("Storage option: ${datasetModel.storageOption}");
      _healthDataService.startStreaming(onData: (healthDataModels) async {
        List<TSHealth> tsHealthList = healthDataModels
            .map((healthDataModel) => TSHealth(
                  tsHealthId: uuid.v4(),
                  sessionId: _sessionID,
                  startTimestamp:
                      healthDataModel.startTimestamp.toUtc().toIso8601String(),
                  endTimestamp:
                      healthDataModel.endTimestamp.toUtc().toIso8601String(),
                  category: healthDataModel.category,
                  unit: healthDataModel.unit,
                  value: healthDataModel.value.toString(),
                ))
            .toList();

        // Perform the batch insert of the TSHealth list
        try {
          if (datasetModel.storageOption == "LOCAL") {
            await _tsHealthRepository.insertBatch(tsHealthList);
          } else {
            dataTransport.sendData('ts-health', {
              "data":
                  tsHealthList.map((tsHealth) => tsHealth.toMap()).toList(),
            });
          }

          log("Batch insertion of health data completed successfully.");
        } catch (e) {
          log("Failed to insert health data: $e");
        }
      });
      _inertialDataService.startCollecting((inertialDataModel) {
        final tsInertial = TSInertial(
          tsInertialId: uuid.v4(),
          sessionId: _sessionID,
          timestamp: inertialDataModel.timestamp.toUtc().toIso8601String(),
          smartphoneAccelerometerTimestamp: inertialDataModel
              .smartphoneAccelerometerTimestamp
              ?.toUtc()
              .toIso8601String(),
          smartphoneAccelerometerX: inertialDataModel.smartphoneAccelerometerX,
          smartphoneAccelerometerY: inertialDataModel.smartphoneAccelerometerY,
          smartphoneAccelerometerZ: inertialDataModel.smartphoneAccelerometerZ,
          smartphoneGyroscopeTimestamp: inertialDataModel
              .smartphoneGyroscopeTimestamp
              ?.toUtc()
              .toIso8601String(),
          smartphoneGyroscopeX: inertialDataModel.smartphoneGyroscopeX,
          smartphoneGyroscopeY: inertialDataModel.smartphoneGyroscopeY,
          smartphoneGyroscopeZ: inertialDataModel.smartphoneGyroscopeZ,
          smartphoneMagnometerTimestamp: inertialDataModel
              .smartphoneMagnometerTimestamp
              ?.toUtc()
              .toIso8601String(),
          smartphoneMagnometerX: inertialDataModel.smartphoneMagnometerX,
          smartphoneMagnometerY: inertialDataModel.smartphoneMagnometerY,
          smartphoneMagnometerZ: inertialDataModel.smartphoneMagnometerZ,
        );
        if (datasetModel.storageOption == "LOCAL") {
          _tsInertialRepository.insert(tsInertial);
        } else {
          dataTransport.sendData('ts-inertial', tsInertial.toMap());
        }
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
    dataTransport.disconnect();
    _healthDataService.stopStreaming();
    _inertialDataService.stopCollecting();
    _session = _session.copyWith(endTimestamp: endTimestamp.toIso8601String());
    await _apiClient.patch('/session', _session.toMap(), id: _sessionID);
  }
}
