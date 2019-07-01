package;

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
    if (includeCenter) n.push(this);
    return n;
  }

  public function toPixel (): Vector {
    var x = 16 * this.x + 8 * this.z;
    var y = 13 * this.z;
    return new Vector(x, y);
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
}