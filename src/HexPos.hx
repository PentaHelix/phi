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

  public var x(get, set): Int;
  public var y(get, set): Int;
  public var z(get, set): Int;

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

  @:op(A * B)
  public function scale (rhs: Int) {
    return new HexPos(get_x() * rhs, get_y() * rhs, get_z() * rhs);
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
    return base + offset;
  }

  public static function deserialize (s: Int): HexPos {
    if (s == 0) return HexPos.ZERO;
    var d: Int = 6;
    var base: Int = 0;
    while (d < s) {
      s -= d;
      base += d;
      d += 6;
    }

    var r: Int = cast d/6;
    base++;
    var offset: Int = s-1;

    var posBase = new HexPos(r, -r, 0);

    var dir = 0;
    while (offset > r) {
      posBase = new HexPos(-posBase.z, -posBase.x, -posBase.y);
      offset -= r;
      dir++;
    }

    posBase += offsets[(dir + 2) % 6] * offset;

    return posBase;
  }

  // getters / setters

  public function get_x (): Int {
    return cast this.x;
  }

  public function set_x (x: Float) {
    return cast this.x = x;
  }

  public function get_y (): Int {
    return cast this.y;
  }

  public function set_y (y: Float) {
    return cast this.y = y;
  }

  public function get_z (): Int {
    return cast this.z;
  }

  public function set_z (z: Float) {
    return cast this.z = z;
  }
}