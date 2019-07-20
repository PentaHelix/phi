package structureTypes;

import traits.HexStructure;
import rules.HexActorRule.Actor;
import traits.HexTile;

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