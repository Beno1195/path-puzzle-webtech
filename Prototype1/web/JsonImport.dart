import 'dart:convert';
import 'dart:html';

void jsonImport() {
  String url = 'Field.json';

  print("HALLO");
  HttpRequest.getString(url).then((str){
    str.split('Level');
    print(JSON.decode(str));
  });
}