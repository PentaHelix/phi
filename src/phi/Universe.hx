package phi;

import h2d.Layers;
import h2d.Scene;

class Universe {
  public var s2d: Scene;
  public var root: Layers;
  public var entities:Array<Entity> = [];

  public function new (s2d: Scene) {
    this.s2d = s2d;
    this.root = new Layers(s2d);
  }

  public function addEntity (e: Entity) {
    entities.push(e);
  }

  public function removeEntity (e: Entity) {
    entities.remove(e);
  }
}