import 'Tile.dart';

/**
 * This class functions as model of the path puzzle
 */
class Field {

  /** holds all tiles of the field */
  List<List<Tile>> _tiles;
  List<int> selectA = [];
  List<int> start = [];
  /** Basic constructor */
  Field(List<List<Tile>> this._tiles) {
    for(int i=0;i<_tiles.length;i++){
      for(int j=0;j<_tiles[i].length;j++)
        {
          if(_tiles[i][j].getType == "I"){
            start.add(i);
            start.add(j);
          }
        }
    }
  }

  /** Getter that converts the Field for the visualization*/
  List<List<String>> get getField {
    List<List<String>> ret = [];
    for (int i = 0; i < _tiles.length; i++) {
      List<String> row = [];

      for (int j = 0; j < _tiles[i].length; j++) {
        if (!_tiles[i][j].getHidden) {
          row.add(_tiles[i][j].getType);
        } else
          row.add("?");
      }
      ret.add(row);
    }
    return ret;
  }

  String select(int row, int col) {
    if (_tiles[row][col].getHidden) {
      _tiles[row][col].visit();
      return "Is Hidden";
    }
    else {
      if (selectA.length == 0) {
        selectA.add(row);
        selectA.add(col);
        return "select";
      }
      else {
        switchTiles(selectA[0], selectA[1], row, col);
        selectA.clear();
        return "switch";
      }
    }
  }


  /** core function to switch two tiles */
  bool switchTiles(int aZ, int aS, int bZ, int bS) {
    Tile temp;
    if (_tiles[aZ][aS].switchable == "true" &&
        _tiles[bZ][bS].switchable == "true") {
      temp = _tiles[aZ][aS];
      _tiles[aZ][aS] = _tiles[bZ][bS];
      _tiles[bZ][bS] = temp;

      return true;
    }

    else {
      return false;
    }
  }


  bool findPath() {

   /* List<Tile> visited = [];
    List<Tile> next = [];
    Tile current = _tiles[start[0]][start[1]];

    if(current.getAccessPoints.contains("N"))
    next.add(_tiles[0][0]);

    next.add(_tiles[start[0]][start[1]];
    */
    return false;
  }
}