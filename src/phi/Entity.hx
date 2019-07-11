package phi;

import haxe.CallStack;
import haxe.ds.IntMap;

abstract Entity(Int) to Int from Int {
  private static var entity_count = 0;
  public function new (t: Array<Trait>, u: Universe) {
    this = entity_count++;
    Game.registerEntity(this, u);
    u.addEntity(this);
    addTraits(t);
  }

  public function addTraits (traits: Array<Trait>) {
    for (trait in traits) {
      phi.Game.entities.get(this).traits.set(trait.hashCode());
      phi.Game.entities.get(this).data.set(trait.hashCode(), trait);
    }

    Game.match(this);
  }

  public function getTrait (id: Int) {
    return Game.entities.get(this).data.get(id);
  }

  public inline function destroy () {
    Game.removeEntity(this);
  }
}
