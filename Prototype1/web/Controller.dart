import 'Field.dart';
import 'Tile.dart';
import 'View.dart';
import 'dart:html';
import 'dart:convert';

/**
 * This class reacts to user input
 */

/** Reference to the view*/
View _view;

/** Reference to the field*/
Field _field;

/** Data for the Gamemode **/
String gameMode = "casual";

List<String> inputTyps =[];
List<String> outputTyps = [];

Map _tiledata;
Map _leveldata;

String currentLevel = "";


void loadTileData() {
  var url = "Tiles.json";

  // call the web server asynchronously
  HttpRequest.getString(url).then(prepareView);

}

void loadLevelData(){
  var url = "Level.json";

  // call the web server asynchronously
  HttpRequest.getString(url).then(loadLevel);
}

void loadLevel(String jsonString){
  _leveldata = JSON.decode(jsonString);
  startMenu();
}

/** Placeholder for a JSON-Implementation**/
  void prepareView(String jsonString) {

    List<List<String>> imageList = new List<List<String>>();
     _tiledata = JSON.decode(jsonString);

    _tiledata.forEach((key,value) {
      imageList.add([key,value["Path"]]);
      if(value["Input"]== true){
        inputTyps.add(key);
      }
      else if(value["Output"] == true){
        outputTyps.add(key);
      }
    });

    _view = new View(imageList, []);
    loadLevelData();
  }

/** Function to switch the Menus in the view **/
switchMenu(Element toShow, Element toHide) {
  if (toShow != null) {
    toShow.classes.add("visible");
    toShow.classes.remove("invisible");
  }

  if (toHide != null) {
    toHide.classes.add("invisible");
    toHide.classes.remove("visible");
  }
}

List<List<Tile>> genarateLevel(String levelID) {


  List<List<Tile>> ret = new List<List<Tile>>();
  Map level = _leveldata[levelID];

  String current= "";
  List<List<String>> field = level["Field"];


  for(int i=0;i<field.length;i++) {
    List<Tile> row = [];
    for(int j=0;j<field[i].length;j++){
       current = field[i][j];
       if(_tiledata.containsKey(current)){
          if(inputTyps.contains(current) || outputTyps.contains(current)){
            row.add(new Tile(current, false, _tiledata[current]["accessPoints"],_tiledata[current]["switchable"]));
          }
          else{
            row.add(new Tile(current, level["Hidden"], _tiledata[current]["accessPoints"],_tiledata[current]["switchable"]));

          }
       }
       else{
         row.add(new Tile("", false, [],"false"));
       }
    }
    ret.add(row);
  }
    return ret;
  }

void startMenu(){

    String _currentLevel = "Level 1";
    currentLevel = _currentLevel;
    _view.startGame.onClick.listen((e) async {

      _field = new Field(genarateLevel(currentLevel),inputTyps,outputTyps);
      _view.loadField(_field.getField);
      game();
      switchMenu(_view.game, _view.menu);
    });
    _view.levelSelect.onClick.listen((e) async {
      switchMenu(_view.level, _view.menu);
      levelselect();
    });
    _view.casualMode.onClick.listen((e) async{
      gameMode = "casual";
    });
    _view.counterMode.onClick.listen((e) async{
      gameMode = "counter";
    });
    _view.timerMode.onClick.listen((e) async{
      gameMode = "timer";
    });
  }
void game(){

    int maxCounter = _leveldata[currentLevel]["Counter"];
    int counter = 0;
    _view.log.innerHtml = "";
    _view.returnButtonGame.onClick.listen((e) async {
      switchMenu(_view.menu, _view.game);
      startMenu();
    });

    for (int row = 0; row < _field.getField.length; row++) {
      for (int col = 0; col < _field.getField[row].length; col++) {
        Element tile = querySelector('#gameField td[col="${col}"][row="${row}"]');
        tile.onClick.listen((ev) {
          String feedback = _field.select(row, col);

          if(feedback == "select"){
            tile.classes.add("selected");
          }
          if(feedback == "switch") {

            _view.removeSelction(_field.getField);
            if(gameMode == "counter") {
              counter++;
              if (counter > maxCounter) {

                switchMenu(_view.popUp, _view.game);
                popUp("GAME OVER!");
              }
              _view.log.innerHtml = "counter: $counter";
            }
          }

          _view.updateField(_field.getField);

          if(_field.findPath()){
            switchMenu(_view.popUp, _view.game);
            popUp("Gewonnen!");
          }
        });
      }
    }
}
/** Menu Element for the Level-Selection**/
void levelselect(){

  List<String> levels = [];
  _leveldata.forEach((key,value){
    levels.add(key);
  });
  _view.updateLevelCatalog(levels);

  for(int i= 0;i<levels.length;i++){
    String content = levels[i];
    Element level = querySelector('#levelCatalog td[content = "$content"]');
    level.onClick.listen((ev) {
      currentLevel = content;
      _field = new Field(genarateLevel(currentLevel),inputTyps,outputTyps);
      _view.loadField(_field.getField);
      game();
      switchMenu(_view.game, _view.level);
    });
  }



  _view.returnButtonLevel.onClick.listen((e) async {
    switchMenu(_view.menu, _view.level);
    startMenu();
  });
}

/** A PopUp to inform the player if he loose or won **/
void popUp(String text){
  _view.updatePopUp("<h1>$text</h1>");
  _view.returnButtonPopUp.onClick.listen((e) async{
    switchMenu(_view.menu, _view.popUp);
    startMenu();
  });
}

main() {
   loadTileData();
}