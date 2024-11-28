//copilot
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class BolgguriTest extends StatefulWidget {
  const BolgguriTest({super.key});

  @override
  State<BolgguriTest> createState() => _BolgguriTestState();
}

class _BolgguriTestState extends State<BolgguriTest> {
  InAppWebViewController? _webViewController;
  final InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    clearCache: true,
    // mixedContentMode: MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    // useOnGeolocationPermissionsShowPrompt: true,
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
        title: const Text('Menu'),
        actions: <Widget>[
          _webViewController != null ? NavigationControls(webViewController: _webViewController!) : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              // initialUrlRequest: URLRequest(url: WebUri('https://192.168.219.119:8443/nearBolgguriApp')),
              initialUrlRequest: URLRequest(url: WebUri('https://www.bluelegend.net/nearBolgguriApp')),
              initialSettings: settings,
              onWebViewCreated: (controller) {
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
              //     meta.content = "upgrade-insecure-requests";
              //     document.getElementsByTagName('head')[0].appendChild(meta);
              //   ''');
              // },
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







// //gpt's code
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class BolgguriTest extends StatefulWidget {
//   const BolgguriTest({super.key});
//
//   @override
//   State<BolgguriTest> createState() => _BolgguriTestState();
// }
//
// class _BolgguriTestState extends State<BolgguriTest> {
//   late InAppWebViewController _webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('볼꺼리 페이지'),
//         actions: <Widget>[
//           NavigationControls(webViewController: _webViewController),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: InAppWebView(
//               initialUrlRequest: URLRequest(url: WebUri('https://aws.bluelegend.net/nearBolgguriTest')),
//               onWebViewCreated: (controller) {
//                 _webViewController = controller;
//               },
//               onLoadStop: (controller, url) async {
//                 // 페이지가 로드된 후 JavaScript 실행
//                 await controller.evaluateJavascript(
//                     source:
//                     "document.querySelector('.material-symbols-outlined').remove();");
//               },
//               onConsoleMessage: (controller, consoleMessage) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text("Console Message: ${consoleMessage.message}")));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _callJavascriptFunction(String functionName) {
//     _webViewController.evaluateJavascript(source: functionName);
//   }
// }
//
// class NavigationControls extends StatelessWidget {
//   const NavigationControls({super.key, required this.webViewController});
//
//   final InAppWebViewController webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             if (await webViewController.canGoBack()) {
//               await webViewController.goBack();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No back history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () async {
//             if (await webViewController.canGoForward()) {
//               await webViewController.goForward();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No forward history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.replay),
//           onPressed: () => webViewController.reload(),
//         ),
//       ],
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
//
// class BolgguriTest extends StatefulWidget {
//   const BolgguriTest({super.key});
//
//   @override
//   State<BolgguriTest> createState() => _BolgguriTestState();
// }
//
// class _BolgguriTestState extends State<BolgguriTest> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     late final PlatformWebViewControllerCreationParams params;
//     params = const PlatformWebViewControllerCreationParams();
//
//     final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageFinished: (String url) {
//           // 페이지가 로드된 후 JavaScript 실행
//           _controller.runJavaScript(
//             // "document.querySelector('.material-symbols-outlined').style.display = 'none';" // 태그 숨기기
//               "document.querySelector('.material-symbols-outlined').remove();" // 태그 삭제
//             // 또는 삭제: "document.getElementById('home').remove();"
//           );
//           _controller.runJavaScript('''
//               var meta = document.createElement('meta');
//               meta.httpEquiv = "Content-Security-Policy";
//               meta.content = "upgrade-insecure-requests";
//               document.getElementsByTagName('head')[0].appendChild(meta);
//         ''');
//         },
//       ))
//       ..clearCache()
//       ..loadRequest(Uri.parse('https://aws.bluelegend.net/nearBolgguriTest'));
//
//     _controller = controller;
//   }
//
//
//   void _callJavascriptFunction(String functionName) {
//     _controller.runJavaScript(functionName);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('볼꺼리 페이지'),
//         actions: <Widget>[
//           NavigationControls(webViewController: _controller),
//           // SampleMenu(webViewController: _controller),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: WebViewWidget(controller: _controller),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NavigationControls extends StatelessWidget {
//   const NavigationControls({super.key, required this.webViewController});
//
//   final WebViewController webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             if (await webViewController.canGoBack()) {
//               await webViewController.goBack();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No back history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () async {
//             if (await webViewController.canGoForward()) {
//               await webViewController.goForward();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No forward history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.replay),
//           onPressed: () => webViewController.reload(),
//         ),
//       ],
//     );
//   }
// }
