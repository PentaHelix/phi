package;

import h3d.Vector;

abstract HexPos(Vector) {
  public function new (x: Int, y: Int, z: Int) {
    this = new Vector(x, y, z);
  }
}