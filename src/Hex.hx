package;

import haxe.ds.IntMap;
using Math;
using Lambda;

class Hex {
  public static function distance (from: HexPos, to:HexPos) {
    return Math.max(Math.max((from.x - to.x).abs(), (from.y - to.y).abs()), (from.z - to.z).abs());
  }

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

    return new HexPos(rx, ry, rz);
  }

  public static function outline (src: Array<HexPos>) {
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
      result.push(HexPos.deserialize(k));
    }

    return result;
  }
}