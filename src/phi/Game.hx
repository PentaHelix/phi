package phi;

import haxe.ds.IntMap;

typedef EntityInfo = {
  traits: Traits,
  data: IntMap<Trait>,
  universe: Universe
}
class Game extends hxd.App {
  public static var universe: Universe;
  public static var dt: Float;
  public static var entities: IntMap<EntityInfo> = new IntMap<EntityInfo>();

  override public function new () {
    super();
  }

  override public function update (dt: Float) {
    Game.dt = dt;
    tick();
    Game.universe.tick();
  }

  public function tick () {}

  public static function warpTo (u: Universe) {
    Game.universe = u;
  }

  public static function registerEntity (e: Entity, u: Universe) {
    Game.entities.set(e, {
      traits: new Traits([]),
      universe: u,
      data: new IntMap<Trait>()
    });
  }

  public static function removeEntity (e: Entity) {
    Game.entities.get(e).universe.removeEntity(e);
    Game.entities.remove(e);
  }

  public static function match (e: Entity) {
    Game.entities.get(e).universe.match(e);
  }
}