package phi;

abstract Group (Array<Entity>) {
  public function new () {
    this = [];
  }

  public function add (e: Entity) {
    this.push(e);
  }

  public function enable () {
    for (e in this) {
      e.enable();
    }
  }

  public function disable () {
    for (e in this) {
      e.disable();
    }
  }
}