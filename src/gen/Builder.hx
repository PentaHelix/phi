package gen;

import traits.HexMap;
import controllers.Controller;
import traits.HexActorData;
import traits.HexStructure;
import traits.HexTransform;
import phi.Entity;
import structureTypes.StructureType;
import phi.Universe;

class Builder {
  private static var m: HexMap;
  public static function build (name: String, m: HexMap) {
    var level = C.levels.get(name);
    var generator = getGenerator(level.generator);
    Builder.m = m;
    generator(m, level);
  }

  public static function structure (p: HexVec, name: String, type: StructureType): Entity {
    return new Entity([
      new HexTransform(p),
      new HexStructure(Builder.m, name, type)
    ]);
  }

  public static function actor (p: HexVec, name: String, controller: Controller): Entity {
    return new Entity([
      new HexTransform(p),
      new HexActorData(Builder.m, name, controller),
    ]);
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