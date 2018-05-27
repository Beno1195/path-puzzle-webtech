import 'Field.dart';
import 'Tile.dart';
import 'View.dart';

/**
 * This class reacts to user input
 */

/** Reference to the view*/
View _view;

/** Reference to the field*/
Field _field;

  void prepareGame(){

    // TODO load from JSOM
    List<List<Tile>> tiles = [[new Tile("SW", false, ["S","W"])],
                              [new Tile("SW", false, ["S","W"])],
                              [new Tile("SW", false, ["S","W"])]];

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
    _view = new View(imageList);
  }

  main(){


    _view.updateField(_field.getField);
  }
