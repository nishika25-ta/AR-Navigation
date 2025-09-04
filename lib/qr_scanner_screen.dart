import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';



class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver {
  String? _scannedUrl;
  WebViewController? _webViewController;
  bool _isWebViewLoading = true;
  bool _permissionGranted = false;
  bool _isCheckingPermission = true;
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
    _checkCameraPermission();
  }

  void _initializeScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: true,
    );
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
        _isCheckingPermission = false;
      });
    } else {
      final result = await Permission.camera.request();
      setState(() {
        _permissionGranted = result.isGranted;
        _isCheckingPermission = false;
      });

      if (!_permissionGranted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.camera_alt_outlined, color: Colors.orange),
          SizedBox(width: 10),
          Text('Camera Permission'),
        ]),
        content: const Text(
          'This app needs camera access to scan QR codes. Please grant permission in your device settings.',
        ),
        actions: [
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(); // Go back to previous screen
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!_permissionGranted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (_scannedUrl == null) {
          _scannerController.start();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden: // Handle the hidden state as well
        _scannerController.stop();
        break;
      case AppLifecycleState.detached:
        _scannerController.stop(); // Also stop on detached
        break;
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty && _scannedUrl == null) {
      final String? url = capture.barcodes.first.rawValue;

      if (url != null && Uri.tryParse(url)?.isAbsolute == true) {
        _scannerController.stop();

        setState(() {
          _scannedUrl = url;
          _webViewController = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(Colors.white)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (String url) => setState(() => _isWebViewLoading = true),
                onPageFinished: (String url) => setState(() => _isWebViewLoading = false),
                onWebResourceError: (WebResourceError error) {
                  setState(() => _isWebViewLoading = false);
                  _showErrorDialog(
                    'Failed to Load Page',
                    'Could not load the webpage. Please check the URL and your internet connection.',
                  );
                },
              ),
            );

          // === ANDROID-SPECIFIC CONFIGURATION (The Fix) ===
          if (_webViewController!.platform is AndroidWebViewController) {
            final androidController = _webViewController!.platform as AndroidWebViewController;
            androidController.setMediaPlaybackRequiresUserGesture(false);

            // This intercepts the permission request from the web page and grants it.
            androidController.setOnPlatformPermissionRequest(
                  (PlatformWebViewPermissionRequest request) async {
                // Grant all requested permissions by default for simplicity in this example.
                // In a production app, you might want to be more specific.
                if (request.types.contains(WebViewPermissionResourceType.camera)) {
                  await request.grant();
                } else {
                  await request.deny();
                }
              },
            );

          }

          _webViewController!.loadRequest(Uri.parse(_scannedUrl!));
        });
      } else {
        _showErrorDialog(
          'Invalid QR Code',
          'The scanned QR code does not contain a valid URL.',
        );
      }
    }
  }

  void _showErrorDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
        ]),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              if (_scannedUrl == null && _permissionGranted) {
                _scannerController.start();
              }
            },
          ),
        ],
      ),
    );
  }

  void _resetScanner() {
    setState(() {
      _webViewController?.loadRequest(Uri.parse('about:blank'));
      _scannedUrl = null;
      _webViewController = null;
      _isWebViewLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _permissionGranted) {
        _scannerController.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_scannedUrl == null ? 'Scan WebAR QR Code' : 'WebAR View'),
        backgroundColor: const Color(0xFF004D40), // Dark Teal
        foregroundColor: Colors.white,
        leading: _scannedUrl != null
            ? IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close WebAR View',
          onPressed: _resetScanner,
        )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isCheckingPermission) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004D40))),
            SizedBox(height: 16),
            Text('Checking camera permission...'),
          ],
        ),
      );
    }

    if (!_permissionGranted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.no_photography_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Camera permission is required to scan QR codes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkCameraPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return _scannedUrl == null ? _buildQrScannerView() : _buildWebView();
  }

  Widget _buildQrScannerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Align Your Camera Directly at the QR Code to .',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF004D40).withOpacity(0.7), width: 4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _handleBarcode,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Error. Please   align the QR code with you phone.',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildWebView() {
    if (_webViewController == null) {
      return const Center(child: Text('Error: WebView not initialized.'));
    }

    return Stack(
      children: [
        WebViewWidget(controller: _webViewController!),
        if (_isWebViewLoading)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004D40))),
                SizedBox(height: 16),
                Text('Navigate to WebAR'),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    _webViewController?.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }
}