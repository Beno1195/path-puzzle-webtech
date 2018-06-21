import 'dart:convert';
import 'dart:html';

void jsonImport() {
  String url = 'test.json';

  print("HALLO");
  HttpRequest.getString(url).then((str){
    print(JSON.decode(str));
  });
}