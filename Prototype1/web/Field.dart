import 'Tile.dart';

/**
 * This class functions as model of the path puzzle
 */
class Field {

  /**Holds all tiles of the field */
  List<List<Tile>> _tiles;

  /**A List of input- and outputTyps so its easy to add new through the Tile.json */
  List<String> _inputTyps = [];
  List<String> _outputTyps = [];

  /**Holds the first selected tile*/
  List<int> _selectA = [];

  /**Holds the in- and outputs of the current field*/
  List<Tile> _output = [];
  List<Tile> _input = [];

  /** Basic constructor */
  Field(List<List<Tile>> this._tiles,List<String>this._inputTyps,List<String>this._outputTyps) {
    for (int i = 0; i < _tiles.length; i++) {
      for (int j = 0; j < _tiles[i].length; j++) {
        _tiles[i][j].xPosition = i;                         //initialization of the tile-positions
        _tiles[i][j].yPosition = j;
        if (_outputTyps.contains(_tiles[i][j].getType)) {   //determination of the in- and outputs of the current field
          _output.add(_tiles[i][j]);
        }
        else if (_inputTyps.contains(_tiles[i][j].getType)) {
          _input.add(_tiles[i][j]);
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

  /**Method to set a selection by the player*/
  String select(int row, int col) {
    if (_tiles[row][col].getHidden) {
      _tiles[row][col].visit();
      return "Is Hidden";
    }
    else if (_tiles[row][col].switchable == "true") {
      if (_selectA.length == 0) {
        _selectA.add(row);
        _selectA.add(col);
        return "select";
      }
      else {
        switchTiles(_selectA[0], _selectA[1], row, col);  //if the current selection is the second one, both tiles get switched
        _selectA.clear();
        return "switch";
      }
    }
  }

  /** core function to switch two tiles */
  void switchTiles(int aX, int aY, int bX, int bY) {
    Tile tempA;
    Tile tempB;
    tempA = _tiles[aX][aY];
    tempB = _tiles[bX][bY];
    _tiles[aX][aY] = tempB;
    _tiles[bX][bY] = tempA;

    /**Sync of the coordinates**/
    for (int i = 0; i < _tiles.length; i++) {
      for (int j = 0; j < _tiles[i].length; j++) {
        _tiles[i][j].xPosition = i;
        _tiles[i][j].yPosition = j;
      }
    }
  }

  /**checks if the current tile is connected with the target*/
  bool checkConnection(Tile currentTile,String target) {

    currentTile.setVisited(true);
    bool value = false;

    if ((_inputTyps.contains(currentTile.getType)&& target == "IN") || (_outputTyps.contains(currentTile.getType)&& target == "OUT")) {
      return true;
    }
    /**Checks the neighbors of all for possible sites*/
    if (currentTile.getAccessPoints.contains("N")) {
      if (currentTile.xPosition - 1 >= 0) {
        Tile neighbor = _tiles[currentTile.xPosition - 1][currentTile.yPosition];
        if (neighbor.getAccessPoints.contains("S") && !neighbor.getVisited) {
          if(!value) {
            value = checkConnection(neighbor,target);
          }
        }
      }
    }

    if (currentTile.getAccessPoints.contains("S")) {
      if (currentTile.xPosition + 1 < _tiles.length) {
        Tile neighbor = _tiles[currentTile.xPosition + 1][currentTile.yPosition];
        if (neighbor.getAccessPoints.contains("N") && !neighbor.getVisited) {
          if(!value) {
            value = checkConnection(neighbor,target);
          }
        }
      }
    }

    if (currentTile.getAccessPoints.contains("W")) {
      if (currentTile.yPosition - 1 >= 0) {
        Tile neighbor = _tiles[currentTile.xPosition][currentTile.yPosition - 1];
        if (neighbor.getAccessPoints.contains("E") && !neighbor.getVisited) {
          if(!value) {
            value = checkConnection(neighbor,target);
          }
        }
      }
    }

    if (currentTile.getAccessPoints.contains("E")) {
      if (currentTile.yPosition + 1 < _tiles[currentTile.xPosition].length) {
        Tile neighbor = _tiles[currentTile.xPosition][currentTile.yPosition + 1];
        if (neighbor.getAccessPoints.contains("W") && !neighbor.getVisited) {
          if(!value) {
            value = checkConnection(neighbor,target);
          }
        }
      }
    }
    return value;
  }

  /**Resets the visited-attribute of all tiles*/
  void resetVisited(){
    for (int i = 0; i < _tiles.length; i++) {
      for (int j = 0; j < _tiles[i].length; j++) {
        _tiles[i][j].setVisited(false);
      }
    }
  }

  /**Checks if all in- and outputs are connected*/
  bool findPath() {

    bool ret = true;

    for(int i =0;i<_output.length;i++){                        //all outputs have to be connected
      resetVisited();
      if(ret) {
        ret = checkConnection(_output[i],"IN");
      }
    }
    for(int i =0;i<_input.length;i++){                           //all inputs have to be connected
      resetVisited();
      if(ret) {
        ret = checkConnection(_input[i],"OUT");
      }
    }
    return ret;
  }
}