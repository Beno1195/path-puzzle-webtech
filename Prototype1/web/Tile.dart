/**
 * This class functions as Data-Container for the Tiles
 */
class Tile {

  /** Attributes */
  String _type;
  bool _isHidden = true;
  List<String> _accessPoints;
  bool _visited = false;

  int xPosition = 0;
  int yPosition = 0;

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
  void setVisited(bool value)=> _visited = value;
 }

