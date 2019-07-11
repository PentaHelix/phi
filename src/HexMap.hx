package;

import phi.Universe;
import phi.Entity;
import haxe.ds.Vector;

class HexMap {
  public var radius: Int;
  public var tiles: Vector<HexTile>;

  public function new (radius: Int) {
    this.radius = radius;
    this.tiles = new Vector<HexTile>(radius * (radius + 1) * 3 + 1);
  }

  public function set (area: Array<HexVec>, id: Int) {
    for (p in area) {
      tiles[p.serialize()] = new HexTile(id);
    }
  }

  public function fill (area: Array<HexVec>, id: Int) {
    for (p in area) {
      if (tiles[p.serialize()] == null) tiles[p.serialize()] = new HexTile(id);
    }
  }

  public function inBounds (hex: HexVec) {
    return Hex.distance(HexVec.ZERO, hex) <= radius;
  }

  public function createTiles (u: Universe) {
    for (pos in 0...tiles.length) {
      if (tiles[pos] == null) continue;
      new Entity([
        new HexTransform(HexVec.deserialize(pos)),
        tiles[pos]
      ], u);
    }
  }
}