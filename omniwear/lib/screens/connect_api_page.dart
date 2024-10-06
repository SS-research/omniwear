import 'package:flutter/material.dart';
import 'package:omniwear/api/api_client.dart';
import 'package:omniwear/config/config_manager.dart';
import 'package:omniwear/screens/dataset_list_page.dart';

class ConnectApiPage extends StatefulWidget {
  @override
  _ConnectApiPageState createState() => _ConnectApiPageState();
}

class _ConnectApiPageState extends State<ConnectApiPage> {
  final TextEditingController _baseUrlController = TextEditingController(text: ConfigManager.instance.config.baseUrl);
  late ApiClient _apiClient;
  bool _isLoading = false; // Flag to indicate loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input field for the base URL
            TextField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                labelText: 'Base URL',
                hintText: 'Enter the API base URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between input and buttons

            // Show loader while API call is in progress
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Container(), // Empty container when not loading

            const SizedBox(height: 20), // Add spacing before buttons

            // Submit button to connect to API
            ElevatedButton(
              onPressed: _isLoading
                  ? null // Disable button if loading
                  : () async {
                      final baseUrl = _baseUrlController.text;
                      if (baseUrl.isNotEmpty) {
                        await _connectToApi(baseUrl);
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a base URL')),
                          );
                        }
                      }
                    },
              child: const Text('Connect to API'),
            ),
            const SizedBox(height: 10), // Add a bit of spacing

            // Clear button
            ElevatedButton(
              onPressed: () {
                _baseUrlController.clear();
                setState(() {
                  _isLoading = false;
                });
                // If in loading state, we do not need to cancel anything since we do not have a cancellable task
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Optional: change button color
              ),
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to connect to the API and check health
  Future<void> _connectToApi(String baseUrl) async {
    // Update the ConfigManager with the new base URL
    ConfigManager.instance.config.updateBaseUrl(baseUrl);

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      // Create the ApiClient instance with the entered baseUrl
      _apiClient = ApiClient();

      // Make a GET request to the /healthcheck endpoint
      final response = await _apiClient.get('/healthcheck');

      // Check if widget is still mounted before using context
      if (mounted) {
        // Handle response and display appropriate message
        if (response != null) {
          // Show success message and navigate to StartSessionPage
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connection successful!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DatasetListPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('API is not reachable')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred')),
        );
      }
    } finally {
      // Set loading state to false
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }
}
