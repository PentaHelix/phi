package gen;

import controllers.Controller;
import traits.HexActor;
import traits.HexStructure;
import traits.HexTransform;
import phi.Entity;
import structureTypes.StructureType;
import phi.Universe;

class Builder {
  private static var u: Universe;
  private static var m: HexMap;
  public static function build (name: String, u: Universe, m: HexMap) {
    var level = C.levels.get(name);
    var generator = getGenerator(level.generator);
    Builder.u = u;
    Builder.m = m;
    generator(m, level);
  }

  public static function commitTiles () {
    m.createTiles(u);
  }

  public static function structure (p: HexVec, name: String, type: StructureType) {
    new Entity([
      new HexTransform(p),
      new HexStructure(name, type)
    ], u);
  }

  public static function actor (p: HexVec, name: String, controller: Controller) {
    new Entity([
      new HexTransform(p),
      new HexActor(name, controller),
    ], u);
  }

  public static function hero (p: HexVec) {
    new Entity([
      new HexTransform(p),
      new HexActor("hero", new controllers.Hero()),
      new traits.Hero()
    ], u);
  }

  private static function getGenerator(name: String) {
    switch (name) {
      case "fortress":
        return Fortress.make;
      default:
        return null;
    }
  }
}