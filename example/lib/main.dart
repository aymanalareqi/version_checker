import 'package:flutter/material.dart';
import 'package:version_checker/version_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Version Checker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Version Checker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VersionCheckResponse? _lastResponse;
  bool _isLoading = false;
  String _status = 'Ready to check for updates';

  // Create different version checker configurations
  final _defaultChecker = VersionChecker();

  late final _customChecker = VersionChecker(
    config: const VersionCheckerConfig(
      apiUrl: 'https://salawati.smart-fingers.com/api/version/check',
      timeoutSeconds: 15,
      locale: 'ar',
      updateDialogConfig: DialogConfig(
        title: 'New Update Available! 🎉',
        message:
            'We\'ve made some awesome improvements. Update now to get the latest features!',
        positiveButtonText: 'Update Now',
        negativeButtonText: 'Maybe Later',
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        messageStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        elevation: 8,
      ),
      forceUpdateDialogConfig: DialogConfig(
        title: 'Critical Update Required ⚠️',
        message:
            'This version contains important security fixes. Please update immediately.',
        positiveButtonText: 'Update Now',
        showNegativeButton: false,
        backgroundColor: Colors.red,
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        messageStyle: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
        barrierDismissible: false,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    if (_isLoading) ...[
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Basic Version Check
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Version Check',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Check for updates with default configuration'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () =>
                                    _checkVersion(_defaultChecker, 'Default'),
                            child: const Text('Check with Dialogs'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _checkVersionQuietly(
                                    _defaultChecker, 'Default (Quiet)'),
                            child: const Text('Check Quietly'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Custom Styled Version Check
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Styled Check',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Check with custom dialog styling and configuration'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _checkVersion(_customChecker, 'Custom'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Check with Custom Dialogs'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Manual Dialog Testing
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manual Dialog Testing',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Test different dialog types manually'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showUpdateDialog(),
                          child: const Text('Update Dialog'),
                        ),
                        ElevatedButton(
                          onPressed: () => _showForceUpdateDialog(),
                          child: const Text('Force Update'),
                        ),
                        ElevatedButton(
                          onPressed: () => _showErrorDialog(),
                          child: const Text('Error Dialog'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Last Response
            if (_lastResponse != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Response',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildResponseDetails(_lastResponse!),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Utility Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Utility Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _clearCache(),
                            child: const Text('Clear Cache'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _getAppVersion(),
                            child: const Text('Get App Version'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Version checking methods
  Future<void> _checkVersion(VersionChecker checker, String type) async {
    setState(() {
      _isLoading = true;
      _status = 'Checking for updates ($type)...';
    });

    try {
      final response = await checker.checkForUpdatesQuietly();

      setState(() {
        _lastResponse = response;
        _status = response.success
            ? (response.updateAvailable
                ? 'Update available: ${response.latestVersion}'
                : 'No update available')
            : 'Error: ${response.error}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkVersionQuietly(VersionChecker checker, String type) async {
    setState(() {
      _isLoading = true;
      _status = 'Checking for updates ($type)...';
    });

    try {
      final response = await checker.checkForUpdatesQuietly();

      setState(() {
        _lastResponse = response;
        _status = response.success
            ? (response.updateAvailable
                ? 'Update available: ${response.latestVersion}'
                : 'No update available')
            : 'Error: ${response.error}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showUpdateDialog() {
    final mockResponse = VersionCheckResponse(
      success: true,
      currentVersion: '1.0.0',
      platform: 'ios',
      updateAvailable: true,
      latestVersion: '1.1.0',
      forceUpdate: false,
      downloadUrl: 'https://apps.apple.com/app/example',
      releaseNotes: 'Bug fixes and performance improvements',
    );

    VersionChecker.showUpdateDialog(
      context,
      response: mockResponse,
      onUpdate: () => _showSnackBar('Update pressed!'),
      onLater: () => _showSnackBar('Later pressed!'),
    );
  }

  void _showForceUpdateDialog() {
    final mockResponse = VersionCheckResponse(
      success: true,
      currentVersion: '1.0.0',
      platform: 'ios',
      updateAvailable: true,
      latestVersion: '2.0.0',
      forceUpdate: true,
      downloadUrl: 'https://apps.apple.com/app/example',
      releaseNotes: 'Critical security update required',
    );

    VersionChecker.showForceUpdateDialog(
      context,
      response: mockResponse,
      onUpdate: () => _showSnackBar('Force update pressed!'),
    );
  }

  void _showErrorDialog() {
    VersionChecker.showErrorDialog(
      context,
      error:
          'Network connection failed. Please check your internet connection.',
      onRetry: () => _showSnackBar('Retry pressed!'),
      onDismiss: () => _showSnackBar('Error dialog dismissed!'),
    );
  }

  Future<void> _clearCache() async {
    await _defaultChecker.clearCache();
    _showSnackBar('Cache cleared successfully!');
  }

  Future<void> _getAppVersion() async {
    try {
      final version = await VersionChecker.getAppVersion();
      _showSnackBar(
          'App Version: ${version['version']}, Build: ${version['buildNumber']}');
    } catch (e) {
      _showSnackBar('Error getting app version: $e');
    }
  }

  Widget _buildResponseDetails(VersionCheckResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Success', response.success.toString()),
        _buildDetailRow('Current Version', response.currentVersion),
        _buildDetailRow('Platform', response.platform),
        if (response.platformLabel != null)
          _buildDetailRow('Platform Label', response.platformLabel!),
        _buildDetailRow(
            'Update Available', response.updateAvailable.toString()),
        if (response.latestVersion != null)
          _buildDetailRow('Latest Version', response.latestVersion!),
        _buildDetailRow('Force Update', response.forceUpdate.toString()),
        if (response.downloadUrl != null)
          _buildDetailRow('Download URL', response.downloadUrl!),
        if (response.releaseNotes != null)
          _buildDetailRow(
              'Release Notes', response.getLocalizedReleaseNotes() ?? 'N/A'),
        if (response.error != null)
          _buildDetailRow('Error', response.error!, isError: true),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
