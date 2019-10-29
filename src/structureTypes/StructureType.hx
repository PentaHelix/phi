package structureTypes;

import traits.HexMap.MapData;
import traits.HexStructure;
import archetypes.Actor;
import traits.HexTile;

@:keepSub
class StructureType {
  public var structure: HexStructure;
  public var tile: MapData;
  
  public function new () {}
  
  public function onPlace (): Void {}
  public function onInteract (a: Actor): Void {}
}