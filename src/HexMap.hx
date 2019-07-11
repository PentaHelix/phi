package;

import traits.HexActor;
import phi.Universe;
import phi.Entity;
import haxe.ds.Vector;

import traits.HexTile;
import traits.HexTransform;

class HexMap {
  public var radius: Int;
  public var data: Vector<MapData>;

  public function new (radius: Int) {
    this.radius = radius;
    this.data = new Vector<MapData>(radius * (radius + 1) * 3 + 1);
    for (i in 0...data.length) {
      data[i] = {
        items: [],
        tile: null,
        actor: null
      }
    }
  }

  public function set (area: Array<HexVec>, name: String) {
    for (p in area) {
      data[p.serialize()].tile = new HexTile(name);
    }
  }

  public function fill (area: Array<HexVec>, name: String) {
    for (p in area) {
      if (data[p.serialize()].tile == null) data[p.serialize()].tile = new HexTile(name);
    }
  }

  public function inBounds (hex: HexVec) {
    return Hex.distance(HexVec.ZERO, hex) <= radius;
  }

  public function findPath (p1: HexVec, p2: HexVec, ?maxLen=9999) {
    if(data[p1.serialize()].tile == null || data[p2.serialize()].tile == null) return null;
    if(!data[p1.serialize()].tile.data.passable) return null;
    if(p1 == p2) return [];

    
  }

  public function createTiles (u: Universe) {
    for (pos in 0...data.length) {
      if (data[pos].tile == null) continue;
      new Entity([
        new HexTransform(HexVec.deserialize(pos)),
        data[pos].tile
      ], u);
    }
  }
}

typedef MapData = {
  var items: Array<String>;
  var tile: HexTile;
  var actor: HexActor;
}

typedef PathNode = {
  var pos: HexVec;
  var previous: PathNode;
}