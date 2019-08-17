package structureTypes;

import rules.HexActorRule.Actor;

class LadderDown extends StructureType {
  override public function onInteract (a: Actor) {
    Manager.inst.warpToLevel(C.levelNames[1]);
  }
}