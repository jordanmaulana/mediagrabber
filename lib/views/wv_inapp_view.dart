import 'dart:collection'; // import 'dart:convertimport 'dart:typed_data';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../providers/media_provider.dart';
import '../utility/constants.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  const InAppWebViewExampleScreen({Key? key}) : super(key: key);

  @override
  _InAppWebViewExampleScreenState createState() =>
      _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  final GlobalKey webViewKey = GlobalKey();
  static const platform = MethodChannel('samples.flutter.dev/grabber');
  int found = 0;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptEnabled: true,
        useOnLoadResource: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                log("Menu item Special clicked!");
                log(await webViewController?.getSelectedText() ?? "noText");
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          log("onCreateContextMenu");
          log(hitTestResult.extra ?? "");
          log(await webViewController?.getSelectedText() ?? "");
        },
        onHideContextMenu: () {
          log("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          log("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaProvider mediaProvider = context.watch<MediaProvider>();
    return Scaffold(
        appBar: AppBar(title: const Text("InAppWebView")),
        floatingActionButton: FloatingActionButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${mediaProvider.videos.length + mediaProvider.images.length + mediaProvider.audios.length}",
                style: const TextStyle(fontSize: 16.0),
              ),
              const Icon(Icons.download),
            ],
          ),
          onPressed: () => Navigator.pushNamed(context, '/downloadMedia'),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
            controller: urlController,
            keyboardType: TextInputType.url,
            onSubmitted: (value) {
              var url = Uri.parse(value);
              if (url.scheme.isEmpty) {
                url = Uri.parse("https://www.google.com/search?q=" + value);
              }
              mediaProvider.clearAll();
              webViewController?.loadUrl(urlRequest: URLRequest(url: url));
            },
          ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  onLoadNativeResource:
                      (InAppWebViewController webViewController,
                          String url) async {
                    log("resource load ${found++}");
                    platform.invokeMethod(
                      'grabMedia',
                      {
                        "viewUrl": url,
                        "url": url,
                        "title": "TEST",
                      },
                    ).then((value) {
                      log("got response $value");
                      mediaProvider.addResourse(value);
                    });
                  },
                  onLoadResource: (InAppWebViewController webViewController,
                      LoadedResource source) async {
                    // await platform
                    //     .invokeMethod('getBatteryLevel')
                    //     .then((value) {
                    //   log("got battery $value");
                    // });
                  },
                  // contextMenu: contextMenu,
                  initialUrlRequest: URLRequest(url: Uri.parse(webSamples[3])),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidShouldInterceptRequest: (controller, request) async {
                    var url = request.url.toString();
                    var i = 0;
                    while (i < adblock.length) {
                      if (url.contains(adblock.elementAt(i))) {
                        return WebResourceResponse();
                      }
                      i++;
                    }
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    // var uri = navigationAction.request.url!;
                    mediaProvider.clearAll();
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    log("url: \n$url\n${url.toString()}");
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    log(consoleMessage.toString());
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.refresh),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
            ],
          ),
        ])));
  }
}
