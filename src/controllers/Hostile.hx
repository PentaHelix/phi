package controllers;

import actions.Action;
import actions.WalkAction;
import actions.WaitAction;
import actions.AttackAction;

import rules.HexActorRule.Actor;

class Hostile implements Controller {
  public var type = 'hostile';
  public var self: Actor;
  var target: Actor;

  public function new () {}

  public function getAction (): Action {
    if (target == null) target = Manager.inst.actors.getNearestNonHostile(self.transform.pos);
    if (target == null) return new WaitAction();

    var map = Manager.inst.map;

    var path = map.findPath(self.transform.pos, target.transform.pos);
    if (path == null || path.length == 0) return new WaitAction();
    
    if (map.at(path[1]).actor == target) return new AttackAction(self, target);
    if (map.at(path[1]).actor != null) return new WaitAction();


    return new WalkAction(self, HexVec.direction(path[1]-self.transform.pos));
  }
}