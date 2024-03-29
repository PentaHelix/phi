package actions;

import ui.Log;
import items.Item;
import archetypes.Actor;

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
    
    Manager.inst.actors.damage(target, dmg);
    Log.info('${self.actor.name} hits ${target.actor.name} for ${dmg} damage');

    return true;
  }
}