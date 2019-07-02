package;

using Math;

class Hex {
  public static function distance (from: HexPos, to:HexPos) {
    return Math.max(Math.max((from.x - to.x).abs(), (from.y - to.y).abs()), (from.x - to.x).abs());
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

  public static function outline (of: Array<HexPos>) {
    
    for (pos in of) {

    }
  }
}