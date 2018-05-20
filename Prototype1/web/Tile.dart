/**
 * This class functions as Data-Container for the Tiles
 */
class Tile {

  /** Attributes */
  String _type;
  bool _isHidden = true;
  List<String> _accessPoints;
  bool _visited = false;

  /** Basic constructor  */
  Tile(String this._type, bool this._isHidden, List<String> this._accessPoints);

  /** Getter for the visualization */
  String get getType => _type;
  bool get getHidden => _isHidden;

  /** Getter for the path algorithm */
  List<String> get getAccessPoints => _accessPoints;
  bool get getVisited => _visited;
 }

