package phi;

import h2d.Layers;
import h2d.Scene;

class Universe {
  public var s2d: Scene;
  public var root: Layers;
  public var entities:Array<Entity> = [];
  public static var passes: Array<Pass> = [];

  public function new (s2d: Scene) {
    this.s2d = s2d;
    this.root = new Layers();
    this.s2d.addChildAt(this.root, 0);
  }

  public function tick () {
    for (pass in passes) {
      pass.tick();
    }
  }

  public function addPass (p: Pass) {
    passes.push(p);
  }

  public function match (e: Entity) {
    entities.push(e);
    for (pass in passes) {
      pass.match(e);
    }
  }

  public function removeEntity (e: Entity) {
    for (pass in passes) {
      pass.removeEntity(e);
    }
    entities.remove(e);
  }

  public function onResize () {
    s2d.x = s2d.width / 2;
    s2d.y = s2d.height / 2;
  }
}