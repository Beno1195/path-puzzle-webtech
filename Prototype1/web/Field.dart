import 'Tile.dart';

/**
 * This class functions as model of the path puzzle
 */
class Field{

  /** holds all tiles of the field */
  List<List<Tile>> _tiles;

  /** Basic constructor */
  Field(List<List<Tile>> this._tiles);

  /** Getter that converts the Field for the visualization*/
  List<List<String>> get getField{

    List<List<String>> ret = [];
    for(int i = 0;i < _tiles.length;i++){
      List<String> row = [];

      for(int j = 0;j<_tiles[i].length;j++) {
        if (!_tiles[i][j].getHidden) {
          row.add(_tiles[i][j].getType);
        } else
          row.add("?");
      }
    ret.add(row);
    }

    return ret;
  }

  /** core function to switch two tiles */
  bool switchTiles(Tile A,Tile B){
    return true;
  }
}