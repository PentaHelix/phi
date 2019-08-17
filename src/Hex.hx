package;

import h3d.Vector;
import haxe.ds.IntMap;
using Math;
using Lambda;

class Hex {
  // geometry
  public static function distance (from: HexVec, to:HexVec): Int {
    return cast Math.max(Math.max((from.x - to.x).abs(), (from.y - to.y).abs()), (from.z - to.z).abs());
  }

  public static function angle (v1: HexVec) {
    var v = v1.toPixel();
    return -Math.atan2(v.y, -v.x);
  }

  public static function outline (src: Array<HexVec>) {
    var outline: IntMap<Bool> = new IntMap<Bool>();
    for (pos in src) {
      pos.neighbors().map(p -> p.serialize()).foreach(s -> {
        outline.set(s, true);
        return true;
      });
    }

    for (pos in src) {
      outline.remove(pos.serialize());
    }

    var result = [];
    for (k in outline.keys()) {
      result.push(HexVec.deserialize(k));
    }


    var sum: Vector = result.fold((v, c) -> {
      return v + c;
    }, HexVec.ZERO);

    sum.scale3(1 / result.length);

    result.sort((v1, v2) -> {
      return angle(v1 - sum) < angle(v2 - sum) ? -1 : 1; 
    });

    return result;
  }

  public static function range (size: Int): Array<HexVec> {
    var result: Array<HexVec> = [];
    for (x in -size...size+1) {
      for (y in -size...size+1) {
        for (z in -size...size+1) {
          if (x + y + z == 0) result.push(new HexVec(x,y,z));
        }
      }  
    }

    return result;
  }

  public static function smoothen (hexes: IntMap<Bool>, exceptions: Array<HexVec>): IntMap<Bool> {
    var removed;
    do {
      removed = false;
      for (p => b in hexes) {
        if (!b) continue;
        var h = HexVec.deserialize(p);
        if (exceptions.indexOf(h) != -1) continue;
        var count = h.neighbors().count(n -> hexes.get(n.serialize()) || exceptions.indexOf(n) != -1);
        if (count <= 1) {
          hexes.set(p, false);
          removed = true;
        }
      }
    } while(removed);
    return hexes;
  }

  // utility
  public static function round (x: Float, y: Float, z: Float) {
    var rx = x.round();
    var ry = y.round();
    var rz = z.round();

    var x_diff = (rx - x).abs();
    var y_diff = (ry - y).abs();
    var z_diff = (rz - z).abs();

    if (x_diff > y_diff && x_diff > z_diff) rx = -ry-rz;
    else if (y_diff > z_diff) ry = -rx-rz;
    else rz = -rx-ry;

    return new HexVec(rx, ry, rz);
  }
}