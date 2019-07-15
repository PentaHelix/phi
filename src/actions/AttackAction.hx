package actions;

import rules.HexActorRule.Actor;

class AttackAction implements Action {
  var self: Actor;
  var target: Actor;
  
  public function new (self: Actor, target: Actor) {
    this.self = self;
    this.target = target;
  }

  public function perform () {
    return true;
  }
}