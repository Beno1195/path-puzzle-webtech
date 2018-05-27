import 'Field.dart';
import 'Tile.dart';
import 'View.dart';

/**
 * This class reacts to user input
 */

/** Reference to the view*/
View _view = new View();

/** Reference to the field*/
Field _field;

  void prepareGame(){

    // TODO load from JSOM
    List<List<Tile>> tiles = [[new Tile("SW", false, ["S","W"])],
                              [new Tile("SW", false, ["S","W"])],
                              [new Tile("SW", false, ["S","W"])]];

    _field = new Field(tiles);
  }

  main(){


    
    _view.updateField(_field.getField);

  }
