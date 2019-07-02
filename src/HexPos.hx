package;

import hl.BaseType;
import h3d.Vector;

@:forward
abstract HexPos(Vector) from Vector to Vector {
  public static var ZERO: HexPos = new HexPos(0,0,0);
  public static var offsets: Array<HexPos> = [
    new HexPos(1, -1, 0),
    new HexPos(0, -1, 1),
    new HexPos(-1, 0, 1),
    new HexPos(-1, 1, 0),
    new HexPos(0, 1, -1),
    new HexPos(1, 0, -1),
  ];

  public function new (x: Int, y: Int, z: Int) {
    this = new Vector(x, y, z);
  }

  // utility
  public function neighbors (includeCenter: Bool = false): Array<HexPos> {
    var n = offsets.map(o -> o + this);
    if (includeCenter) n.unshift(this);
    return n;
  }

  public function toPixel (): Vector {
    var x = 16 * this.x + 8 * this.z;
    var y = 13 * this.z;
    return new Vector(x, y);
  }

  public static function fromPixel (pixel: Vector): HexPos {
    var q = pixel.x / 16 - pixel.y / 26;
    var r = pixel.y / 13;
    // trace('$q, $r');
    return Hex.round(q, -q-r, r);
  }

  // operators
  @:op(A + B)
  public function add (rhs: HexPos) {
    return new HexPos(cast(this.x + rhs.x), cast(this.y + rhs.y), cast(this.z + rhs.z));
  }

  @:op(A - B)
  public function sub (rhs: HexPos) {
    return new HexPos(cast(this.x - rhs.x), cast(this.y - rhs.y), cast(this.z - rhs.z));
  }

  // serialization
  public function serialize (): Int {
    var r = Hex.distance(this, ZERO);
    // r * (r - 1) / 2 * 6 + 1
    var base: Int = r == 0 ? 0 : Math.round(r * (r - 1) * 3) + 1;
    var pixel: Vector = toPixel();
    var angle = Math.atan2(pixel.y, pixel.x) / (2*Math.PI);
    if (angle < 0) angle += 1;
    var offset: Int = Math.round(angle * r * 6);
    // trace('${this}: ${base} + ${offset}');
    return base + offset;
  }

  public static function deserialize (s: Int): HexPos {
    var d: Int = 6;
    var base: Int = 0;
    while (d < s) {
      s -= d;
      base += d;
      d += 6;
    }

    // trace('${base+1} + ${s-1}');
    return HexPos.ZERO;
  }
}