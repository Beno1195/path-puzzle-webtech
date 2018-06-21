import 'Field.dart';
import 'Tile.dart';
import 'View.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'JsonImport.dart';

/**
 * This class reacts to user input
 */

/** Reference to the view*/
View _view;

/** Reference to the field*/
Field _field;

String gameMode = "casual";
int counter = 0;
  void prepareGame() {
    List<List<Tile>> tiles = [[
      new Tile("I", false, ["S"]),
      new Tile("", false, []),
      new Tile("", false, []),
      new Tile("", false, [])
    ],
    [
      new Tile("SE", true, ["S", "E"]),
      new Tile("H", true, ["W", "E"]),
      new Tile("SW", true, ["S", "W"]),
      new Tile("SE", true, ["S", "E"])
    ],
    [
      new Tile("SE", true, ["S", "E"]),
      new Tile("H", true, ["W", "E"]),
      new Tile("SW", true, ["S", "W"]),
      new Tile("SE", true, ["S", "E"])
    ],
    [
      new Tile("V", true, ["N", "S"]),
      new Tile("SW", true, ["S", "W"]),
      new Tile("V", true, ["N", "S"]),
      new Tile("V", true, ["N", "S"])
    ],
    [
      new Tile("NE", true, ["N", "E"]),
      new Tile("H", true, ["W", "E"]),
      new Tile("NW", true, ["N", "W"]),
      new Tile("NE", true, ["N", "E"])
    ],
    [
      new Tile("", false, [""]),
      new Tile("O", false, ["N"]),
      new Tile("", false, []),
      new Tile("", false, [""])
    ]
    ];

     List<List<String>> imageList = [["NE","Path_corner_NE.png"],
                                   ["NW","Path_corner_NW.png"],
                                   ["SE","Path_corner_SE.png"],
                                   ["SW","Path_corner_SW.png"],
                                   ["H","Path_horizontal.png"],
                                   ["V","Path_vertical.png"],
                                   ["?","Path_hidden.png"],
                                   ["I","Input.png"],
                                   ["O","Output.png"]];


    _field = new Field(tiles);
    _view = new View(imageList, _field.getField);
  }

_switchMenu(Element toShow, Element toHide) {
  if (toShow != null) {
    toShow.classes.add("visible");
    toShow.classes.remove("invisible");
  }

  if (toHide != null) {
    toHide.classes.add("invisible");
    toHide.classes.remove("visible");
  }
}

void startMenu(){
    _view.startGame.onClick.listen((e) async {
      game(_field.getField);
      _switchMenu(_view.game, _view.menu);
      //_view.updateLog(gameMode);
    });
    _view.levelSelect.onClick.listen((e) async {
      _switchMenu(_view.level, _view.menu);
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
void game(List<List<String>> levelContent){

    int maxCounter = 20;

    _view.returnButtonGame.onClick.listen((e) async {
      _switchMenu(_view.menu, _view.game);
      //_view.loadField(levelContent);
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
            counter++;
            _view.removeSelction(_field.getField);
            /*if(_field.findPath()){
              _switchMenu(_view.popUp, _view.game);
              popUp("GEWONNEN!");
            }*/
            if (counter > maxCounter) {
              _switchMenu(_view.popUp, _view.game);
              popUp("GAME OVER!");
            }
          }
          _view.log.innerHtml = "counter: $counter";
          _view.updateField(_field.getField);
        });
      }
    }
}
void levelselect(){
  _view.returnButtonLevel.onClick.listen((e) async {
    _switchMenu(_view.menu, _view.level);
    startMenu();
  });
}

void popUp(String text){
  _view.updatePopUp("<h1>$text</h1>");
  _view.returnButtonPopUp.onClick.listen((e) async{
    _switchMenu(_view.menu, _view.popUp);
    startMenu();
  });
}
main()
{
    jsonImport();
    prepareGame();
    startMenu();
}