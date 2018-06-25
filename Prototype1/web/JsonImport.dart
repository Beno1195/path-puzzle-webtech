import 'dart:convert';
import 'dart:html';

void jsonImport() {
  String url = 'Field.json';

  print("HALLO");
  HttpRequest.getString(url).then((str){
    str.split('Level');
    Map data = JSON.decode(str);

    data.forEach((int index, Map level) {
    data[""];
    });

  });
}