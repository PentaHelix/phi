package traits;

class HexTile implements phi.Trait {
  public var tileId: Int;
  public var name: String;
  public var passable: Bool;
  public var transparent: Bool;

  public function new (name: String) {
    this.name = name;
    var data = C.tiles.get(name);
    tileId = data.id;
    passable = data.passable;
    transparent = data.transparent;
  }
}