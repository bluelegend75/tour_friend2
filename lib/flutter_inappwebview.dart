import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Bolgguri extends StatefulWidget {
  const Bolgguri({super.key});

  @override
  State<Bolgguri> createState() => _BolgguriState();
}

class _BolgguriState extends State<Bolgguri> {
  late InAppWebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('볼꺼리 페이지'),
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://aws.bluelegend.net/nearBolgguri"),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  // mixedContentMode: MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE, // Mixed Content Mode 설정
                ),
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
                _controller.addJavaScriptHandler(
                  handlerName: 'Toaster',
                  callback: (args) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(args[0])),
                    );
                  },
                );
              },
              onLoadStop: (controller, url) async {
                // 페이지가 로드된 후 JavaScript 실행
                await controller.evaluateJavascript(
                  source:
                  "document.querySelector('.material-symbols-outlined').remove();",
                );
              },
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
