package rules.actorRule;

import traits.HexMap;
import archetypes.Actor;

class Status {
  public function new () {
  
  }

  public function damage (a: Actor, dmg: Int) {
    a.actor.health -= dmg;
    if (a.actor.health <= 0) {
      a.actor.map.at(a.transform.pos).actor = null;
      a.entity.destroy();
    }
  }
}