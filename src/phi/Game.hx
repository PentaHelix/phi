package phi;

import haxe.ds.IntMap;

typedef EntityInfo = {
  traits: Traits,
  data: IntMap<Trait>,
  universe: Universe
}
class Game extends hxd.App {
  public static var passes: Array<Pass> = [];
  public static var universe: Universe;
  public static var dt: Float;
  public static var entities: IntMap<EntityInfo> = new IntMap<EntityInfo>();

  override public function new () {
    super();
  }

  override public function update (dt: Float) {
    Game.dt = dt;
    tick();
    for (pass in passes) {
      pass.tick();
    }
  }

  public function tick () {}

  public function warpTo (u: Universe) {
    if (universe != null) {
      for (e in universe.entities) {
        for (pass in passes) {
          pass.removeEntity(e);
        }
      }
    }

    Game.universe = u;
    setScene(u.s2d);
    
    for (e in universe.entities) {
      for (pass in passes) {
        pass.match(e);
      }
    }

    for (pass in passes) {
      pass.onWarp(u);
    }
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
    for (pass in passes) {
      pass.match(e);
    }
  }

  public function addPass (p: Pass) {
    passes.push(p);
  }
}