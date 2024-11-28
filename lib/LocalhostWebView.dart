import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
//copilot
class LocalhostWebView extends StatefulWidget {
  const LocalhostWebView({super.key});

  @override
  State<LocalhostWebView> createState() => _LocalhostWebViewState();
}

class _LocalhostWebViewState extends State<LocalhostWebView> {
  InAppWebViewController? _webViewController;
  final InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    clearCache: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localhost copilot'),
        actions: <Widget>[
          _webViewController != null ? NavigationControls(webViewController: _webViewController!) : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('https://www.bluelegend.net/nearBolgguriApp')),
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
                return GeolocationPermissionShowPromptResponse(allow: true, origin:origin, retain: false);
              },
              // onLoadStop: (controller, url) async {
              //   await controller.evaluateJavascript(source: '''
              //     var meta = document.createElement('meta');
              //     meta.httpEquiv = "Content-Security-Policy";
              //     meta.content = "script-src 'self' https://dapi.kakao.com;";
              //     document.getElementsByTagName('head')[0].appendChild(meta);
              //   ''');
              // },
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
