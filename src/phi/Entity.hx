package phi;

import haxe.ds.IntMap;

class Entity{
  private static var entityCount = 0;

  public var id(default, null):Int;

  private var universe: Universe;

  private var traits: IntMap<Trait>;

  public function new(t: Array<Trait>, ?u: Universe) {
    id = entityCount++;
    if (u == null) u = Game.universe;
    universe = u;
    addTraits(t);
  }

  public function addTraits(t: Array<Trait>) {
    for(trait in traits) {
      traits.set(trait.hashCode(), trait);
    }
    universe.match(this);
  }
}