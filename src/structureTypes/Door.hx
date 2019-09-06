package structureTypes;

import rules.HexActorRule.Actor;

class Door extends StructureType {
  override public function onPlace () {
    tile.passable = false;
    tile.transparent = false;
  }
  
  override public function onInteract(a: Actor) {
    structure.setState("open");
    tile.passable = true;
    tile.transparent = true;
  }
}