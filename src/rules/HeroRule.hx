package rules;

import phi.Entity;
import phi.Archetype;
import phi.Game;
import phi.Rule;
import traits.HexTransform;

class Hero extends Archetype {
  @:trait 
  public var hero: traits.Hero;
  @:trait 
  public var transform: HexTransform;
}

class HeroRule implements Rule<Hero> {
  public function tick () {
    for (e in entities) {
      if (e.hero.cameraFocused) {
        var pos = e.transform.screenPos;
        Game.universe.root.setPosition(-pos.x, -pos.y);
      }
    }
  }
}