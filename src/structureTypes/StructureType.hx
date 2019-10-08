package structureTypes;

import traits.HexStructure;
import archetypes.Actor;
import traits.HexTile;

@:keepSub
class StructureType {
  public var structure: HexStructure;
  public var tile: HexTile;
  
  public function new () {}
  
  public function onPlace (): Void {}
  public function onInteract (a: Actor): Void {}
}