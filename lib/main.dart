import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:trixie/ui/list.dart';
import 'package:trixie/navigation/NavigationRoute.dart';

void main() => runApp(MyApp());
FlutterWebviewPlugin _flutterWebView = FlutterWebviewPlugin();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Roboto"),
      routes: {
        "/": (_) => WebView(),
      },
    );
  }
}

/// WebView
class WebView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebView> {
  String _url = "https://www.google.com";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: _url,
      appBar: AppBar(title: Text("First WebPage")),
      bottomNavigationBar: bottomNavigation(context),
    );
  }

  @override
  void dispose() {
    _flutterWebView.dispose();
    super.dispose();
  }

  /// Buttons
  Row bottomNavigation(context) {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              openList(context);
            }),
        IconButton(icon: Icon(Icons.phone_android), onPressed: openNativeScreen)
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  ///Actions
  Future openList(BuildContext context) async {
    _flutterWebView.hide();

    await Navigator.push(
        context, new NavigationRoute(builder: (context) => new ListScreen()));

    Future.delayed(Duration(milliseconds: 350), () => _flutterWebView.show());
  }
}

void openNativeScreen() {}