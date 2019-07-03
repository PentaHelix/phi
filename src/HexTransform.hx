package;

class HexTransform implements phi.Trait {
  public var pos: HexPos = new HexPos(0,0,0);
  public var rotation: Int = 0;

  public function new (pos: HexPos) {
    this.pos = pos;
  }
}