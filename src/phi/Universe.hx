package phi;

class Universe {
  private var passes:Array<Pass> = [];
  private var entities:Array<Entity> = [];

  public function new () {}

  public function addPass (p: Pass) {
    passes.push(p);
  }

  public function addEntity (e: Entity) {
    entities.push(e);
  }

  public function tick () {
    for (pass in passes) {
      pass.tick();
    }
  }

  public function match (e: Entity) {
    for (pass in passes) {
      pass.match(e);
    }
  }
}