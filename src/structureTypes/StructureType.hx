package structureTypes;

import traits.HexStructure;
import rules.HexActorRule.Actor;
import traits.HexTile;

class StructureType {
  public var structure: HexStructure;
  public var tile: HexTile;
  
  public function new () {}
  
  public function onPlace (): Void {}
  public function onInteract (a: Actor): Void {}
}