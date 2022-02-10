import 'package:flutter/material.dart';

class MediaProvider extends ChangeNotifier {
  List<String> videos = [];
  List<String> images = [];
  List<String> audios = [];

  addResourse(String data) {
    var result = data.split(" ");
    if (result[0] == "video") {
      videos.add(result[1]);
    } else if (result[0] == "audio") {
      audios.add(result[1]);
    } else if (result[0] == "image") {
      images.add(result[1]);
    }
    notifyListeners();
  }

  clearAll() {
    videos = [];
    images = [];
    audios = [];
    notifyListeners();
  }
}
