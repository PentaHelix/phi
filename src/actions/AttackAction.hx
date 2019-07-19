package actions;

import items.Item;
import rules.HexActorRule.Actor;

class AttackAction implements Action {
  var self: Actor;
  var target: Actor;
  var item: Item;
  
  public function new (self: Actor, target: Actor, ?item: Item=null) {
    this.self = self;
    this.target = target;
    this.item = item;
  }

  public function perform () {
    var dmg: Int = 0;

    if (item == null) {
      dmg = self.actor.baseAttack.roll();
      var bonus = (self.actor.strength - 10) >> 1;
      dmg += bonus;
    } else {
      // TODO
    }
    target.actor.health -= dmg;
    if (target.actor.health <= 0) {

    }
    return true;
  }
}