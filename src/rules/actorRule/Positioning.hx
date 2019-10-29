package rules.actorRule;

import traits.HexMap;
import archetypes.Actor;

class Positioning {
  public function new () {}

  public function moveTo (a: Actor, pos: HexVec): Bool {
    if (a.actor.map.at(pos).actor != null) return false;

    a.actor.map.at(a.transform.pos).actor = null;
    a.transform.pos = pos;
    a.actor.map.at(a.transform.pos).actor = a;

    sync(a);
    
    return true;
  }

  public function sync (a: Actor) {
    var p = a.transform.pos.toPixel();
    a.sprite.x = p.x;
    a.sprite.y = p.y - 5;
    a.transform.screenPos.x = a.sprite.x;
    a.transform.screenPos.y = a.sprite.y;
  }
}
