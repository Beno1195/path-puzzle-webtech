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

/**Reference to the data of the JSON-Files*/
Map _tiledata;
Map _leveldata;

/**Lists of the input- and outputTypes */
List<String> inputTyps =[];
List<String> outputTyps = [];

/**Data to determine the level for the level-selection*/
List<String> levels = [];

/** Data for the Gamestart */
String gameMode = "casual";
String currentLevel = "";


/**Loads the information about all tiles from the Tiles.json*/
void loadTileData() {
  var url = "Tiles.json";

  // call the web server asynchronously
  HttpRequest.getString(url).then(prepareView);
}

/**Loads the information about all level from the Level.json*/
void loadLevelData(){
  var url = "Level.json";

  // call the web server asynchronously
  HttpRequest.getString(url).then(loadLevel);
}

/**Prepares the view with a List of File-Paths to the image of each Tile, also checks if a Tile-Type is a in- or output and saves that information in the Lists**/
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

  _view = new View(imageList);
  loadLevelData();
}

/**Decodes the Level.json and generates a List for the level-selection*/
void loadLevel(String jsonString){
  _leveldata = JSON.decode(jsonString);
  _leveldata.forEach((key,value){
    levels.add(key);
  });
  startMenu();
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

/**Generates the Level**/
List<List<Tile>> genarateLevel(String levelID) {
  List<List<Tile>> ret = new List<List<Tile>>();
  Map level = _leveldata[levelID];

  String current = "";
  List<List<String>> field = level["Field"];


  for (int i = 0; i < field.length; i++) {
    List<Tile> row = [];
    for (int j = 0; j < field[i].length; j++) {
      current = field[i][j];
      if (_tiledata.containsKey(current)) {
        if (inputTyps.contains(current) ||
            outputTyps.contains(current)) { //inputs and outputs aren't hidden
          row.add(new Tile(current, false, _tiledata[current]["accessPoints"],
              _tiledata[current]["switchable"]));
        }
        else {
          row.add(new Tile(
              current, level["Hidden"], _tiledata[current]["accessPoints"],
              _tiledata[current]["switchable"]));
        }
      }
      else { //if the position in the grid is empty
        row.add(new Tile("", false, [], "false"));
      }
    }
    ret.add(row);
  }
  return ret;
}

/**Checks the user interactions in the main menu*/
void startMenu() {
  String _currentLevel = "Level 1";
  currentLevel = _currentLevel;
  _view.startGame.onClick.listen((e) async {                                //switch to the game (Level 1)
    _field = new Field(genarateLevel(currentLevel), inputTyps, outputTyps);
    _view.loadField(_field.getField);
    game();
    switchMenu(_view.game, _view.menu);
  });
  _view.levelSelect.onClick.listen((e) async {                              //switch to the level-selection
    switchMenu(_view.level, _view.menu);
    levelselect();
  });
  _view.casualMode.onClick.listen((e) async {                               //change the game mode - default
    gameMode = "casual";
  });
  _view.counterMode.onClick.listen((e) async {                              //change the game mode - enables a turn-limit
    gameMode = "counter";
  });
}

/**checks the user interactions during the game*/
void game(){

  int maxCounter = _leveldata[currentLevel]["Counter"];
  int counter = 0;

  _view.log.innerHtml = "";
  _view.returnButtonGame.onClick.listen((e) async {                           //switch to the main menu
    switchMenu(_view.menu, _view.game);
    startMenu();
  });

  /**checks if a valid tile is selected and switches them if a second one is selected */
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

          if(gameMode == "counter") {                                         //if the turn limitation is enabled
            counter++;
            if (counter > maxCounter) {
              switchMenu(_view.popUp, _view.game);
              popUp("GAME OVER!");
            }
            _view.log.innerHtml = "counter: $counter";
          }
        }

        _view.updateField(_field.getField);

        if(_field.findPath()){                                                //Checks if all in- and outputs are connected -> the player wins
          switchMenu(_view.popUp, _view.game);
          popUp("GEWONNEN!");
        }
      });
    }
  }
}

/** Menu Element for the Level-Selection**/
void levelselect(){


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
  int nextIndex = 0;

  if(levels.indexOf(currentLevel)+1 < levels.length) {
    if(text != "GAME OVER!"){
      nextIndex = levels.indexOf(currentLevel) + 1;
      _view.nextLevel.setInnerHtml("Nächstes Level") ;
    }
    else {
      nextIndex = levels.indexOf(currentLevel);
      _view.nextLevel.setInnerHtml("Neuer Versuch") ;
    }
  }
  _view.updatePopUp("<h1>$text</h1>");
  _view.returnButtonPopUp.onClick.listen((e) async{
    switchMenu(_view.menu, _view.popUp);
    startMenu();
  });
  _view.nextLevel.onClick.listen((e) async{
    currentLevel=levels[nextIndex];
    _field = new Field(genarateLevel(currentLevel),inputTyps,outputTyps);
    _view.loadField(_field.getField);
    game();
    switchMenu(_view.game, _view.popUp);
  });
}

/** Main function to start the program */
main() {
  loadTileData();
}