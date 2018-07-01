import 'dart:html';

/**
 * This class visualizes the game
 */

class View {

  /**
   * list of image-paths
   */
  List<List<String>> images;

  /**Element-Selector for easier interactions**/
  final ButtonElement startGame = querySelector("#startButton");
  final ButtonElement levelSelect = querySelector("#levelButton");
  final ButtonElement returnButtonGame = querySelector("#returnGame");
  final ButtonElement returnButtonLevel = querySelector("#returnLevel");
  final ButtonElement returnButtonPopUp = querySelector("#returnPopUp");
  final ButtonElement nextLevel = querySelector("#nextLevel");
  final ButtonElement casualMode = querySelector("#casual");
  final ButtonElement counterMode = querySelector("#counter");

  final Element game = querySelector("#game");
  final Element menu = querySelector("#startMenu");
  final Element level = querySelector("#levelSelect");
  final Element popUp = querySelector("#popUp");

  final Element gameField = querySelector("#gameField");
  final Element log = querySelector("#log");
  final Element massage = querySelector("#massage");

  final Element levelCatalog = querySelector("#levelCatalog");


  /**
   * Basic constructor
   */
  View(List<List<String>> imageList){
    images = imageList;
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
   * updates the  Field
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

  /** removes the selection indicator from the tiles*/
  void removeSelction(List<List<String>> content) {

    for(int row = 0;row < content.length;row++){
      for(int col = 0; col < content[row].length;col++){
        Element element = querySelector('#gameField td[col="${col}"][row="${row}"]');
        element.classes.remove("selected");
      }
    }
  }

  /**initialize the field-table with a validator for row and col*/
  void loadField(List<List<String>> content){

    final validator = new NodeValidatorBuilder.common();
    validator.allowElement('td', attributes: ['row', 'col']);
    querySelector('#gameField').setInnerHtml(toHtmlTable(content),validator: validator);

  }

  /**updates the level catalog for the level-selection */
  void updateLevelCatalog(List<String>name){

    String ret ="";
    final validator = new NodeValidatorBuilder.common();
    validator.allowElement('td', attributes: ['content']);
    for(int i = 0; i< name.length;i++){
      ret += "<tr><td content='${name[i]}'>${name[i]}</td></tr>";
    }
    levelCatalog.setInnerHtml(ret,validator: validator);
  }

  /**updates the log eg. the current counter if turn-limitation is enabled*/
  void updateLog(String content){
    log.innerHtml = content;
  }

  /**shows the massage on the popUp eg. "Game Over!"*/
  void updatePopUp(String content){
    massage.innerHtml = content;
  }
}
