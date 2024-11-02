import 'package:flutter/material.dart';
import 'package:omniwear/api/api_client.dart';
import 'package:omniwear/screens/start_session_page.dart';

// TODO: put in a separate file
class DatasetModel {
  final String datasetId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String inertialFeatures;
  final double inertialCollectionFrequency;
  final int inertialCollectionDurationSeconds;
  final int inertialSleepDurationSeconds;
  final String healthFeatures;
  final int healthReadingFrequency;
  final int healthReadingInterval;
  final String storageOption;

  DatasetModel({
    required this.datasetId,
    required this.createdAt,
    required this.updatedAt,
    required this.inertialFeatures,
    required this.inertialCollectionFrequency,
    required this.inertialCollectionDurationSeconds,
    required this.inertialSleepDurationSeconds,
    required this.healthFeatures,
    required this.healthReadingFrequency,
    required this.healthReadingInterval,
    required this.storageOption,
  });

  factory DatasetModel.fromJson(Map<String, dynamic> json) {
    return DatasetModel(
      datasetId: json['dataset_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      inertialFeatures: json['inertial_features'],
      inertialCollectionFrequency:
          (json['inertial_collection_frequency'] as num).toDouble(),
      inertialCollectionDurationSeconds:
          json['inertial_collection_duration_seconds'],
      inertialSleepDurationSeconds: json['inertial_sleep_duration_seconds'],
      healthFeatures: json['health_features'],
      healthReadingFrequency: json['health_reading_frequency'],
      healthReadingInterval: json['health_reading_interval'],
      storageOption: json['storage_option'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataset_id': datasetId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'inertial_features': inertialFeatures,
      'inertial_collection_frequency': inertialCollectionFrequency,
      'inertial_collection_duration_seconds': inertialCollectionDurationSeconds,
      'inertial_sleep_duration_seconds': inertialSleepDurationSeconds,
      'health_features': healthFeatures,
      'health_reading_frequency': healthReadingFrequency,
      'health_reading_interval': healthReadingInterval,
      'storage_option': storageOption,
    };
  }
}

class DatasetListPage extends StatefulWidget {
  @override
  _DatasetListPageState createState() => _DatasetListPageState();
}

class _DatasetListPageState extends State<DatasetListPage> {
  List<DatasetModel> datasets = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDatasets();
  }

  Future<void> fetchDatasets() async {
    try {
      final response = await ApiClient().get('/dataset');
      setState(() {
        datasets = (response["data"] as List)
            .map((data) => DatasetModel.fromJson(data))
            .toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load datasets: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datasets'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: datasets.length,
                  itemBuilder: (context, index) {
                    final dataset = datasets[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Dataset ID: ${dataset.datasetId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Created At: ${dataset.createdAt}'),
                            Text('Updated At: ${dataset.updatedAt}'),
                            Text(
                                'Inertial Features: ${dataset.inertialFeatures}'),
                            Text('Health Features: ${dataset.healthFeatures}'),
                            Text('Storage Option: ${dataset.storageOption}'),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () {
                          // Handle the tap event, e.g., navigate to another page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StartSessionPage(
                                  key: ValueKey(dataset.datasetId),
                                  datasetModel: dataset),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
