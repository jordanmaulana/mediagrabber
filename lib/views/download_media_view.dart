import 'package:flutter/material.dart';
import 'package:mediagrabber/providers/media_provider.dart';
import 'package:provider/provider.dart';

class DownloadMediaView extends StatelessWidget {
  const DownloadMediaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaProvider mediaProvider = context.watch<MediaProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Media"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("Videos:"),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaProvider.videos.length,
            itemBuilder: (c, i) {
              return ListTile(
                title: Text(mediaProvider.videos[i]),
              );
            },
          ),
          const Divider(),
          const Text("Images:"),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaProvider.images.length,
            itemBuilder: (c, i) {
              return ListTile(
                title: Text(_getFileName(mediaProvider.images[i])),
              );
            },
          ),
          const Divider(),
          const Text("Audios:"),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaProvider.audios.length,
            itemBuilder: (c, i) {
              return ListTile(
                title: Text(mediaProvider.audios[i]),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getFileName(String url) {
    Uri data = Uri.parse(url);
    var split = data.path.split("/");
    return split.last;
  }
}
