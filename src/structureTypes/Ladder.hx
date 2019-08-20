package structureTypes;

import rules.HexActorRule.Actor;

class Ladder extends StructureType {
  private var to: String;

  override public function new (to: String) {
    super();
    this.to = to;
  }

  override public function onInteract (a: Actor) {
    Manager.inst.warpToLevel(this.to);
  }
}