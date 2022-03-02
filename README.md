# mediagrabber

Flutter project to add Native onLoadResource to [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)

## Getting Started

We’re using [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) as a base library
for the browser and will do the modification inside this lib. To use the modified library, move the
library folder to the root folder, adjacent with pubspec.yaml. Then add:

```
flutter_inappwebview:
	path: ./flutter_inappwebview-5.3.2
```

The library has an *onLoadResource()* function, but it is not from native web client. This function
will be executed if it’s controller calls *"onCallJsHandler"* with *"onLoadResource"* passed as an argument. In this manner, it won't be able to load every url as many as native web client should be. That's why we need to add the non existing native *onLoadResource()* to the library web client.

So our primary task is to add ***Native WebClient onLoadResource()*** instead of using *flutter_inappwebview's onLoadResource()*

So navigate to:

```
> flutter_inappwebview
> com
> android
> src
> main
> java
> com
> pichillilorenzo
> flutter_inappwebview
> in_app_webview
	> InAppWebViewClient.java
```

You will now find

```
public class InAppWebViewClient extends WebViewClient {
```

Then add this below override method inside the class

```
@Override
public void onLoadResource(WebView view, String url) {
    super.onLoadResource(view, url);
    channel.invokeMethod("onLoadNativeResource", url);
}
```

Now you have native *onLoadResource()* that is ready to channel to flutter app using *onLoadNativeResource()*

To append this as function ready to be called from Flutter, the logic is simple. Just append the function to every location where library's onLoadResource() is located.

### Modify ```in_app_webview.dart``` and ```headless_in_app_webview.dart``` file.
```in_app_webview.dart``` is located in

```
> flutter_inappwebview
> lib
> src
> in_app_webview
	> in_app_webview.dart
	> headless_in_app_webview.dart.
```


1) Append this function 

```
@override
final void Function(InAppWebViewController controller, String url)?
	onLoadNativeResource;
```
2) Add this into constructor's arguments
 
```
this.onLoadNativeResource,
```

### Modify ```in_app_webview_controller.dart``` file.
```in_app_webview_controller.dart ``` is located adjacent to ```in_app_webview.dart```

Append below function inside ```handleMethod(MethodCall call)``` under ```switch (call.method)```

```
case "onLoadNativeResource":
	String url = call.arguments; //retrieve url thrown from native invokeMethod
	if (_webview != null && _webview!.onLoadStart != null)
	  _webview!.onLoadNativeResource!(this, url);
	break;
```

### Modify ```webview.dart``` file.
```webview ``` is located adjacent to previous files.

1) Append this function

```
final void Function(InAppWebViewController controller, String url)?
      onLoadNativeResource;
```

2) Add this into constructor's arguments

```
this.onLoadNativeResource,
```

## Implementation

Now your InAppWebView is able to catch all url from native web client!

```
InAppWebView(
  onLoadNativeResource:
      (InAppWebViewController webViewController, String url) async {
	// Do url filtering here
  },
),
```