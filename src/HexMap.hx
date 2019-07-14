package;

import ds.VecMap;
import ds.PriorityQueue;
import traits.HexActor;
import phi.Universe;
import phi.Entity;
import haxe.ds.Vector;

import traits.HexTile;
import traits.HexTransform;

using Hex;

class HexMap {
  public var radius: Int;
  public var data: VecMap<MapData>;

  public function new (radius: Int) {
    this.radius = radius;
    this.data = new VecMap<MapData>();
  }

  public function at(v: HexVec) {
    if (data[v] == null) {
      data[v] = {
        items: [],
        tile: null,
        actor: null
      };
    }

    return data[v];
  }

  public function set (area: Array<HexVec>, name: String) {
    for (p in area) {
      at(p).tile = new HexTile(name);
    }
  }

  public function fill (area: Array<HexVec>, name: String) {
    for (p in area) {
      if (at(p).tile == null) at(p).tile = new HexTile(name);
    }
  }

  public function inBounds (hex: HexVec) {
    return Hex.distance(HexVec.ZERO, hex) <= radius;
  }

  public function findPath (p1: HexVec, p2: HexVec, ?maxLen=9999) {
    if(at(p1).tile == null || at(p2).tile == null) return null;
    if(!at(p1).tile.data.passable) return null;
    if(p1 == p2) return [];

    var explored: VecMap<PathNode> = new VecMap<PathNode>();
    var queue:PriorityQueue<PathNode> = new PriorityQueue<PathNode>();
    var dist = Hex.distance(p1, p2);

    queue.enqueue({
      pos: p1,
      prev: null,
      g: 0,
      h: dist,
      f: dist
    }, dist);

    var found: Bool = false;
    var current:PathNode = null;
    while (!queue.isEmpty() && !found) {
      current = queue.dequeue();
      explored[current.pos] = current;
      if(at(current.pos).tile == null) continue;
      if(!at(current.pos).tile.data.passable) continue;

      if (current.pos == p2) {
        found = true;
        break;
      }

      for (n in current.pos.neighbors()) {
        var gScore:Float = current.g + 1;
        var fScore:Float = gScore + Hex.distance(n, p2);
        var ex:PathNode = explored[n];

        if (ex != null && fScore >= ex.f) {
          continue;
        } else if (!queue.contains(ex) || fScore < ex.f) {
          if (ex == null) {
            ex = {
              pos: n,
              prev: null,
              g: 0,
              h: Hex.distance(n, p2),
              f: 0,
            }
          }
          ex.prev = current;
          ex.g = gScore;
          ex.f = fScore;
          if (queue.contains(ex)) {
            queue.remove(ex);
          }

          queue.enqueue(ex, ex.f);
        }
      }
    }

    if (!found) return null;
    var n: PathNode = current;
    var path = [];
    do {
      path.unshift(n.pos);
    } while ((n = n.prev) != null);

    return path;
  }

  public function createTiles (u: Universe) {
    for (h => d in data) {
      if (d.tile == null) continue;
      new Entity([
        new HexTransform(HexVec.deserialize(h)),
        d.tile
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
  var prev: PathNode;
  var f: Float;
  var g: Float;
  var h: Float;
}