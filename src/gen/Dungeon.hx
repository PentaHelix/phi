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

    var maze = [];

    for (h => b in passages) {
      if (b) maze.push(HexVec.deserialize(h));
    }

    return maze;
  }
}