package rules;

import phi.Entity;
import phi.Game;
import phi.Rule;
import traits.HexTransform;

typedef Hero = {
  @:trait 
  var hero: traits.Hero;
  @:trait 
  var transform: HexTransform;
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