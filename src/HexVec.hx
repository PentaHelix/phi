package;

import hl.BaseType;
import h3d.Vector;

@:forward
abstract HexVec(Vector) from Vector to Vector {
  public static var ZERO: HexVec = new HexVec(0,0,0);
  public static var offsets: Array<HexVec> = [
    new HexVec(1, -1, 0),
    new HexVec(0, -1, 1),
    new HexVec(-1, 0, 1),
    new HexVec(-1, 1, 0),
    new HexVec(0, 1, -1),
    new HexVec(1, 0, -1),
  ];

  public var x(get, set): Int;
  public var y(get, set): Int;
  public var z(get, set): Int;

  public function new (x: Int, y: Int, z: Int) {
    this = new Vector(x, y, z);
  }

  // utility
  public function neighbors (includeCenter: Bool = false): Array<HexVec> {
    var n = offsets.map(o -> o + this);
    if (includeCenter) n.unshift(this);
    return n;
  }

  public function toPixel (): Vector {
    var x = 16 * this.x + 8 * this.z;
    var y = 13 * this.z;
    return new Vector(x, y);
  }

  public static function fromPixel (pixel: Vector): HexVec {
    var q = pixel.x / 16 - pixel.y / 26;
    var r = pixel.y / 13;
    return Hex.round(q, -q-r, r);
  }

  // operators
  @:op(A + B)
  public function add (rhs: HexVec) {
    return new HexVec(cast(this.x + rhs.x), cast(this.y + rhs.y), cast(this.z + rhs.z));
  }

  @:op(A - B)
  public function sub (rhs: HexVec) {
    return new HexVec(cast(this.x - rhs.x), cast(this.y - rhs.y), cast(this.z - rhs.z));
  }

  @:op(A * B)
  public function scale (rhs: Int) {
    return new HexVec(get_x() * rhs, get_y() * rhs, get_z() * rhs);
  }

  @:op(A == B)
  public inline function equals (rhs: HexVec) {
    return get_x() == rhs.get_x() && get_y() == rhs.get_y() && get_z() == rhs.get_z();
  }

  @:op(A != B)
  public inline function notEquals (rhs: HexVec) {
    return !equals(rhs);
  }

  private static inline function toNatural (n: Int): Int {
    if (n < 0) {
      return -n*2+1;
    } else {
      return n * 2;
    }
  }

  private static inline function fromNatural (n: Int): Int {
    if (n & 1 == 1) {
      return cast -(n - 1)/2;
    } else {
      return cast n / 2;
    }
  }

  public function serialize (): Int {
    var x = toNatural(get_x());
    var z = toNatural(get_z());
    var max = Math.max(x, z);
    if (max == x) {
      return x*x + x + z;
    } else {
      return z*z + x;
    }
  }

  public static function deserialize (s: Int): HexVec {
    var q = Math.floor(Math.sqrt(s));
    var qs = q*q;
    var x: Int, z: Int;
    if (s - qs < q) {
      x = s - qs;
      z = q;
    } else {
      x = q;
      z = s - qs - q;
    }

    x = fromNatural(x);
    z = fromNatural(z);

    return new HexVec(x, -x-z, z);
  }

  //getters / setters

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