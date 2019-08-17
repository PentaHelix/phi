package rules;

import phi.Game;
import h2d.Scene;
import phi.Rule;
import traits.HexTransform;

typedef Hero = {
  @:trait var hero: traits.Hero;
  @:trait var transform: HexTransform;
}

class HeroRule implements Rule<Hero> {
  public function tick () {
    var s2d = Game.universe.s2d;
    for (e in entities) {
      if (e.hero.cameraFocused) {
        var pos = e.transform.screenPos;
        s2d.setPosition(-pos.x + s2d.width/2, -pos.y + s2d.height/2);
      }
    }
  }
}