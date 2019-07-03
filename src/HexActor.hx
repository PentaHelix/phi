package;

import phi.Trait;

class HexActor implements Trait {
  public var isControlled: Bool = false;
  public var actorId: Int = 0;

  public function new (id: Int) {
    actorId = id;
  }
}