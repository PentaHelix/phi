package traits;

import C.TileData;

class HexTile implements phi.Trait {
  public var tileId: Int;
  public var name: String;
  public var passable: Bool;
  public var castsShadow: Bool;

  public function new (name: String) {
    this.name = name;
    var data = C.tiles.get(name);
    tileId = data.id;
    passable = data.passable;
    castsShadow = data.castsShadow;
  }
}