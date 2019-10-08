package gen;

import controllers.Controller;
import traits.HexActorData;
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

  public static function structure (p: HexVec, name: String, type: StructureType): Entity {
    return new Entity([
      new HexTransform(p),
      new HexStructure(name, type)
    ], u);
  }

  public static function actor (p: HexVec, name: String, controller: Controller): Entity {
    return new Entity([
      new HexTransform(p),
      new HexActorData(name, controller),
    ], u);
  }

  // TODO: replace with automatic type instantiation from name
  private static function getGenerator(name: String) {
    switch (name) {
      case "fortress":
        return Fortress.make;
      default:
        return null;
    }
  }
}