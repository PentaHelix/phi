package structureTypes;

class Furniture extends StructureType {
  override public function onPlace () {
    tile.passable = true;
    tile.transparent = true;
  }
}