package traits;

import h3d.Vector;

class HexTransform implements phi.Trait {
  public var pos: HexVec = new HexVec(0,0,0);
  public var screenPos: Vector = new Vector(0,0,0);
  public var rotation: Int = 0;

  public function new (pos: HexVec) {
    this.pos = pos;
  }
}