package structureTypes;

import rules.HexActorRule.Actor;

class Door extends StructureType {
  override public function onPlace () {
    tile.passable = false;
    tile.castShadow = true;
  }
  
  override public function onInteract(a: Actor) {
    trace('interacted with door');
    structure.setState("open");
    tile.passable = true;
    tile.castShadow = true;
  }
}