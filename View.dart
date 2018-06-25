import 'dart:html';

/**
 * This class visualizes the game
 */

class View {

  /**
   * list of image-paths
   */
  List<List<String>> images;
  
  final ButtonElement startGame = querySelector("#startButton");
  final ButtonElement levelSelect = querySelector("#levelButton");
  final ButtonElement returnButtonGame = querySelector("#returnGame");
  final ButtonElement returnButtonLevel = querySelector("#returnLevel");
  final ButtonElement returnButtonPopUp = querySelector("#returnPopUp");

  final ButtonElement casualMode = querySelector("#casual");
  final ButtonElement timerMode = querySelector("#timer");
  final ButtonElement counterMode = querySelector("#counter");

  final Element game = querySelector("#game");
  final Element menu = querySelector("#startMenu");
  final Element level = querySelector("#levelSelect");
  final Element popUp = querySelector("#popUp");

  final Element gameField = querySelector("#gameField");
  final ElementList tiles = querySelectorAll("#gamefield>*>td");
  final Element log = querySelector("#log");
  final Element massage = querySelector("#massage");
  /**
   * Basic constructor
   */
  View(List<List<String>> imageList,content){
    images = imageList;

    final validator = new NodeValidatorBuilder.common();
    validator.allowElement('td', attributes: ['row', 'col']);
    querySelector('#gameField').setInnerHtml(toHtmlTable(content),validator: validator);
  }


  
  
  
  /**
   * Generates a HTML-Table from the given Field
   */
  String toHtmlTable(List<List<String>> content) {
    String ret = "";

    for(int row = 0;row<content.length;row++){
      ret += "<tr>";
        for(int col = 0;col<content[row].length;col++){
          ret += "<td row='${row}' col='${col}'>";

          for(int i=0;i<images.length;i++){

            if(images[i][0]==content[row][col]) {
              ret += "<img src=""Resources/${images[i][1]}>";
            }
          }

          ret += "</td>";
        }
      ret += "</tr>";
    }
      return ret;
    }

  /**
   * updates the hole Field
   */
  void updateField(List<List<String>> content) {

    for(int row = 0;row < content.length;row++){
      for(int col = 0; col < content[row].length;col++){
        Element element = querySelector('#gameField td[col="${col}"][row="${row}"]');
        for(int i=0;i<images.length;i++){
          if(images[i][0]==content[row][col]){
            element.innerHtml = "<img src=""Resources/${images[i][1]}>";
          }
        }
      }
    }
  }

  void removeSelction(List<List<String>> content) {

    for(int row = 0;row < content.length;row++){
      for(int col = 0; col < content[row].length;col++){
        Element element = querySelector('#gameField td[col="${col}"][row="${row}"]');
        element.classes.remove("selected");
      }
    }
  }
  void loadField(List<List<String>> content){
      gameField.innerHtml=toHtmlTable(content);
  }

  void updateLog(String content){
    log.innerHtml = content;
  }

  void updatePopUp(String content){
    massage.innerHtml = content;
  }

}
