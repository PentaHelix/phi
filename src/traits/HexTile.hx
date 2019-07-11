package traits;

import C.TileData;

class HexTile implements phi.Trait {
  public var tileId: Int = 0;
  public var data: TileData;

  public function new (name: String) {
    data = C.tiles.get(name);
    tileId = data.id;
  }
}