import 'Tile.dart';

/**
 * This class functions as model of the path puzzle
 */
class Field {

  /** holds all tiles of the field */
  List<List<Tile>> _tiles;
  List<int> selectA = [];
  List<int> start = [];
  Tile startTile;

  /** Basic constructor */
  Field(List<List<Tile>> this._tiles) {
    for(int i=0;i<_tiles.length;i++){
      for(int j=0;j<_tiles[i].length;j++)
        {
          _tiles[i][j].x = i;
          _tiles[i][j].y = j;
          if(_tiles[i][j].getType == "I"){
            start.add(i);
            start.add(j);
            startTile = _tiles[i][j];
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

    //print("${_tiles[row][col].x},${_tiles[row][col].y}");
    if (_tiles[row][col].getHidden) {
      _tiles[row][col].visit();
      return "Is Hidden";
    }
    else {
      if(_tiles[row][col].switchable == "true") {
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
  }

  /** core function to switch two tiles */
  void switchTiles(int aZ, int aS, int bZ, int bS) {
    Tile temp;
    temp = _tiles[aZ][aS];
    _tiles[aZ][aS] = _tiles[bZ][bS];
    _tiles[bZ][bS] = temp;
  }


  List<Tile> getNext(Tile currentTile){

    List<Tile> nextTiles = [];

    if (currentTile.getAccessPoints.contains("S") && _tiles[currentTile.x + 1][currentTile.y].getAccessPoints.contains("N")&& !_tiles[currentTile.x + 1][currentTile.y].getVisited) {
      nextTiles.add(_tiles[currentTile.x + 1][currentTile.y]);
    }
    if (currentTile.getAccessPoints.contains("N") && _tiles[currentTile.x - 1][currentTile.y].getAccessPoints.contains("S")&& !_tiles[currentTile.x + 1][currentTile.y].getVisited) {
      nextTiles.add(_tiles[currentTile.x - 1][currentTile.y]);
    }
    if (currentTile.getAccessPoints.contains("E") && _tiles[currentTile.x][currentTile.y+1].getAccessPoints.contains("W")&& !_tiles[currentTile.x + 1][currentTile.y].getVisited) {
      nextTiles.add(_tiles[currentTile.x][currentTile.y + 1]);
    }
    if (currentTile.getAccessPoints.contains("W") && _tiles[currentTile.x][currentTile.y-1].getAccessPoints.contains("E")&& !_tiles[currentTile.x][currentTile.y-1].getVisited) {
      nextTiles.add(_tiles[currentTile.x + 1][currentTile.y - 1]);
    }

    return nextTiles;
  }

  void resetVisit(){
    for(int i=0;i<_tiles.length;i++){
      for(int j=0;j<_tiles[i].length;j++)
      {
        _tiles[i][j].setVisited(false);
      }
    }
  }
  bool findPath(Tile current,List<Tile>next){

    next.addAll(getNext(current));
    current.setVisited(true);
    if(current.getType == "O"){
      return true;
    }
    else {
      while (!next.isEmpty) {
        return findPath(next.removeAt(0), next);
      }
    }
  }

  bool findPathStart() {

   //resetVisit();
   //ist<Tile> nextTiles = getNext(startTile);

    if(_tiles[1][0].getType == "V" &&
        _tiles[2][0].getType == "V" &&
        _tiles[3][0].getType == "V"&&
        _tiles[4][0].getType == "NE"&&
      _tiles[4][1].getType == "SW") {
      return true;
    }

    else if(_tiles[1][0].getType == "V" &&
        _tiles[2][0].getType == "V" &&
        _tiles[3][0].getType == "NE"&&
        _tiles[3][1].getType == "SW"&&
        _tiles[4][1].getType == "V") {
      return true;
    }

  }

}