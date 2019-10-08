package structureTypes;

import archetypes.Actor;

class Ladder extends StructureType {
  private var to: String;
  private var at: String;

  override public function new (to: String, at: String) {
    super();
    this.to = to;
    this.at = at;
  }

  override public function onInteract (a: Actor) {
    Manager.inst.warpToLevel(this.to, this.at);
  }
}