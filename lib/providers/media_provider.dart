import 'package:flutter/material.dart';

class MediaProvider extends ChangeNotifier {
  List<String> videos = [];
  List<String> images = [];
  List<String> audios = [];

  addResourse(String data) {
    var result = data.split(" ");
    if (result[0] == "video") {
      if (!videos.contains(result[1])) {
        videos.add(result[1]);
        notifyListeners();
      }
    } else if (result[0] == "audio") {
      if (!audios.contains(result[1])) {
        audios.add(result[1]);
        notifyListeners();
      }
    } else if (result[0] == "image") {
      if (!images.contains(result[1])) {
        images.add(result[1]);
        notifyListeners();
      }
    }
  }

  clearAll() {
    videos = [];
    images = [];
    audios = [];
    notifyListeners();
  }
}
