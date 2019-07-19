package rules;

import h2d.Scene;
import phi.Rule;
import traits.HexTransform;

typedef Hero = {
  @:trait var hero: traits.Hero;
  @:trait var transform: HexTransform;
}

class HeroRule implements Rule<Hero> {
  var s2d: Scene;
  public function new (s2d: Scene) {
    this.s2d = s2d;
  }
  
  public function tick () {
    for (e in entities) {
      if (e.hero.cameraFocused) {
        var pos = e.transform.screenPos;
        s2d.setPosition(-pos.x + s2d.width/2, -pos.y + s2d.height/2);
      }
    }
  }
}