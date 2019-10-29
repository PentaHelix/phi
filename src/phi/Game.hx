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
  }

  public function tick () {
    universe.tick();
  }

  public function warpTo (u: Universe) {
    // if (universe != null) {
    //   for (e in universe.entities) {
    //     for (pass in passes) {
    //       pass.removeEntity(e);
    //     }
    //   }
    // }

    Game.universe = u;
    // setScene(u.s2d);
    
    // for (e in universe.entities) {
    //   for (pass in passes) {
    //     pass.match(e);
    //   }
    // }

    // for (pass in passes) {
    //   pass.onWarp(u);
    // }
  }

  public static function createEntity (e: Entity) {
    Game.entities.set(e, {
      traits: new Traits([]),
      universe: universe,
      data: new IntMap<Trait>()
    });
  }

  public static function match (e: Entity) {
    universe.match(e);
  }

  public static function removeEntity (e: Entity) {
    Game.entities.get(e).universe.removeEntity(e);
    Game.entities.remove(e);
  }
}