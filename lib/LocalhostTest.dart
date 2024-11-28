import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
//gpt
class LocalhostTest extends StatefulWidget {
  const LocalhostTest({super.key});

  @override
  State<LocalhostTest> createState() => _LocalhostTestState();
}

class _LocalhostTestState extends State<LocalhostTest> {
  InAppWebViewController? _webViewController;
  final InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    clearCache: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request location permission (if needed)
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPT Viewer'),
        actions: <Widget>[
          _webViewController != null
              ? NavigationControls(webViewController: _webViewController!)
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('https://192.168.219.119/nearBolgguriApp'), // Use 10.0.2.2 for Android Emulator
              ),
              initialSettings: settings,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                _webViewController?.clearSslPreferences();
                setState(() {
                  _webViewController = controller;
                });
              },
              onReceivedServerTrustAuthRequest: (controller, request) async {
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                  allow: true,
                  origin: origin,
                  retain: false,
                );
              },
              onLoadStop: (controller, url) async {
                // Inject JavaScript (optional)
                await controller.evaluateJavascript(source: '''
                  console.log("Page loaded successfully.");
                ''');
              },
              // onConsoleMessage: (controller, consoleMessage) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text(consoleMessage.message)),
              //   );
              // },
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}
