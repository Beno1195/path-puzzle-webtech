/**
 * This class functions as Data-Container for the Tiles
 */
class Tile {

  /** Attributes for the representation of the tile*/
  String _type;
  bool _isHidden = true;

  /**Attributes for the Path-finding-algorithm**/
  List<String> _accessPoints;
  bool _visited = false;

  /**Position in the grid ... Makes it easier to determine the neighbours**/
  int xPosition = 0;
  int yPosition = 0;

  /**Attributes for the user interactions**/
  String switchable = "true";

  /** Basic constructor  */
  Tile(String this._type, bool this._isHidden, List<String> this._accessPoints,String this.switchable);

  /** Getter for the visualization */
  String get getType => _type;
  bool get getHidden => _isHidden;

  void visit() {
    _isHidden = false;
  }
  /** Getter for the path algorithm */
  List<String> get getAccessPoints => _accessPoints;
  bool get getVisited => _visited;
  void setVisited(bool status)=> _visited = status;
 }

