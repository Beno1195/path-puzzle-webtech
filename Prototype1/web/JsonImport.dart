import 'dart:convert';
import 'dart:html';
import 'dart:async';
class JsonImport {

  String tilePath = "Tiles.json";

  JsonImport() {}

  void jsonImport() {

    String url = 'Field.json';

    print("HALLO");
    HttpRequest.getString(url).then((str){
      Map data = JSON.decode(str);

      data.forEach((int index, Map level) {
        data["Hidden"]; // gibt alle Daten für z.B. Hidden, Field etc. zurück
      });

    });
  }
}