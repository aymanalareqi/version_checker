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
        // ignore: deprecated_member_use_from_same_package
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

  // Enhanced checker with custom icons and shapes
  late final _enhancedChecker = VersionChecker(
    config: VersionCheckerConfig(
      apiUrl: 'https://salawati.smart-fingers.com/api/version/check',
      timeoutSeconds: 15,
      updateDialogConfig: DialogConfig(
        title: 'Fresh Update Available! ✨',
        message:
            'Experience new features and improvements in this latest version.',
        positiveButtonText: 'Download',
        negativeButtonText: 'Skip',
        icon: Icons.cloud_download,
        iconColor: Colors.green,
        iconSize: 72,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.green, width: 2),
        ),
        backgroundColor: Colors.green.shade50,
        titleStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
        ),
        messageStyle: TextStyle(
          fontSize: 16,
          color: Colors.green.shade700,
        ),
        elevation: 12,
      ),
      forceUpdateDialogConfig: DialogConfig(
        title: 'Security Update Required',
        message:
            'This update contains critical security patches. Update now to stay protected.',
        positiveButtonText: 'Secure Now',
        showNegativeButton: false,
        icon: Icons.security,
        iconColor: Colors.red.shade700,
        iconSize: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.red.shade50,
        titleStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade800,
        ),
        messageStyle: TextStyle(
          fontSize: 16,
          color: Colors.red.shade700,
        ),
        barrierDismissible: false,
        elevation: 16,
      ),
      errorDialogConfig: DialogConfig(
        title: 'Connection Error',
        message:
            'Unable to check for updates. Please verify your internet connection.',
        positiveButtonText: 'Retry',
        negativeButtonText: 'Cancel',
        icon: Icons.wifi_off,
        iconColor: Colors.orange.shade600,
        iconSize: 68,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.orange.shade300, width: 1),
        ),
        backgroundColor: Colors.orange.shade50,
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade800,
        ),
        messageStyle: TextStyle(
          fontSize: 15,
          color: Colors.orange.shade700,
        ),
        elevation: 8,
      ),
    ),
  );

  // Modern circular design checker
  late final _modernChecker = VersionChecker(
    config: VersionCheckerConfig(
      apiUrl: 'https://salawati.smart-fingers.com/api/version/check',
      timeoutSeconds: 15,
      updateDialogConfig: DialogConfig(
        title: 'Update Ready',
        message: 'A newer version is available with enhanced performance.',
        positiveButtonText: 'Install',
        negativeButtonText: 'Later',
        icon: Icons.rocket_launch,
        iconColor: Colors.purple,
        iconSize: 76,
        shape: const CircleBorder(),
        backgroundColor: Colors.purple.shade50,
        titleStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.purple.shade800,
        ),
        messageStyle: TextStyle(
          fontSize: 16,
          color: Colors.purple.shade600,
        ),
        elevation: 20,
        padding: const EdgeInsets.all(32),
      ),
      forceUpdateDialogConfig: DialogConfig(
        title: 'Mandatory Update',
        message: 'This update is required to continue using the application.',
        positiveButtonText: 'Update',
        showNegativeButton: false,
        icon: Icons.priority_high,
        iconColor: Colors.deepOrange,
        iconSize: 84,
        shape: const StadiumBorder(),
        backgroundColor: Colors.deepOrange.shade50,
        titleStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange.shade800,
        ),
        messageStyle: TextStyle(
          fontSize: 16,
          color: Colors.deepOrange.shade700,
        ),
        barrierDismissible: false,
        elevation: 24,
        padding: const EdgeInsets.all(28),
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

            // Enhanced Icon & Shape Check
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enhanced Icons & Shapes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Check with custom icons, colors, and dialog shapes'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () =>
                                    _checkVersion(_enhancedChecker, 'Enhanced'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Check with Enhanced Dialogs'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _simulateError(
                                    _enhancedChecker, 'Enhanced Error'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Test Error Dialog'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Modern Circular Design Check
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modern Circular Design',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Check with circular and stadium-shaped dialogs'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _checkVersion(_modernChecker, 'Modern'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Check with Modern Dialogs'),
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
      final response = await checker.checkForUpdates(
        context: context,
        showDialogs: true,
        onResult: (response) {
          // Update the UI with the response
          setState(() {
            _lastResponse = response;
          });
        },
        onUpdatePressed: () {
          _showSnackBar('Update button pressed! Opening app store...');
        },
        onLaterPressed: () {
          _showSnackBar('Later button pressed. Update postponed.');
        },
        onDismissed: () {
          _showSnackBar('Dialog dismissed.');
        },
        onError: () {
          _showSnackBar('Error occurred during version check.');
        },
      );

      setState(() {
        _lastResponse = response;
        _status = response.success
            ? (response.updateAvailable
                ? 'Update available: ${response.latestVersion} (Dialog shown)'
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

  Future<void> _simulateError(VersionChecker checker, String type) async {
    setState(() {
      _isLoading = true;
      _status = 'Simulating error ($type)...';
    });

    try {
      // Simulate an error by calling with an invalid URL
      final errorChecker = VersionChecker(
        config: checker.config.copyWith(
          apiUrl: 'https://invalid-url-that-will-fail.com/api/version/check',
        ),
      );

      await errorChecker.checkForUpdates(context: context);
    } catch (e) {
      setState(() {
        _status = 'Error simulated: $e';
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
