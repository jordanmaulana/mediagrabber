import 'package:flutter/material.dart';
import 'package:mediagrabber/providers/media_provider.dart';
import 'package:mediagrabber/views/download_media_view.dart';
import 'package:provider/provider.dart';

import 'views/wv_inapp_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MediaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Grabber',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const InAppWebViewExampleScreen(),
        '/downloadMedia': (context) => const DownloadMediaView(),
      },
    );
  }
}