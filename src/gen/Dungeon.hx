package gen;

import HexMap.PathNode;
import ds.PriorityQueue;
import haxe.ds.IntMap;
using Hex;
using Utils;
using Lambda;

class Dungeon {
  public static inline var ROOM_MIN_SIZE = 8;
  public static inline var ROOM_MAX_SIZE = 20;

  public static function room (): Array<HexVec> {
    var hexes = [HexVec.ZERO];

    while (hexes.length < ROOM_MIN_SIZE || Math.random() > hexes.length / ROOM_MAX_SIZE) {
      var outline = hexes.outline();
      if (Math.random() > hexes.length / ROOM_MAX_SIZE * 1.2) {
        hexes.push(outline.random());
      } else {
        hexes = hexes.concat(outline);
      }
    }

    return hexes;
  }

  public static function maze (initialPassages: Array<HexVec>, initialWalls: Array<HexVec>, size: Int) {
    var passages: IntMap<Bool> = new IntMap<Bool>();
    var walls: IntMap<Bool> = new IntMap<Bool>();
    var open: Array<HexVec> = initialPassages.copy();

    for (p in initialPassages) {
      open.push(p);
    }

    for (w in initialWalls) {
      walls.set(w.serialize(), true);
    }

    while (open.length != 0) {
      var h = open.random();
      open.remove(h);

      
      var count = h.neighbors().count(n -> passages.get(n.serialize()));
      if (count > 2) continue;

      var last = passages.get(h.neighbors()[5].serialize());
      var shouldOpen = true;
      for (n in h.neighbors()) {
        if (last && passages.get(n.serialize())) shouldOpen = false;
        last =  passages.get(n.serialize());
      }

      if (shouldOpen) {
        passages.set(h.serialize(), true);
        walls.set(h.serialize(), false);
      } else {
        walls.set(h.serialize(), true);
        passages.set(h.serialize(), false);
      }

      for (n in h.neighbors()) {
        if (passages.get(n.serialize())) continue;
        if (walls.get(n.serialize())) continue;
        if (Hex.distance(HexVec.ZERO, n) >= 18) continue;

        open.push(n);
      }
    }
    
    return passages;
  }

  public static function corridor (w: Array<HexVec>, maze: IntMap<Bool>, p1: HexVec, p2: HexVec) {
    var explored: IntMap<PathNode> = new IntMap<PathNode>();
    var queue:PriorityQueue<PathNode> = new PriorityQueue<PathNode>();
    var dist = Hex.distance(p1, p2);

    var walls: IntMap<Bool> = new IntMap<Bool>();
    for (wall in w) {
      walls.set(wall.serialize(), true);
    }

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
      explored.set(current.pos.serialize(), current);

      if (current.pos == p2) {
        found = true;
        break;
      }

      for (n in current.pos.neighbors()) {
        if(walls.get(n.serialize()) == true && n != p2) continue;

        var gScore:Float = current.g + 1;
        var fScore:Float = gScore + Hex.distance(n, p2);
        // if (maze.get(n.serialize())) fScore /= 2;

        var ex:PathNode = explored.get(n.serialize());

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
          if (ex.pos == p1) continue;
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
      trace(n.pos);
      path.unshift(n.pos);
    } while ((n = n.prev) != null);

    return path;
  }
}

typedef MazeNode = {
  var pos: HexVec;
  var prev: MazeNode;
}