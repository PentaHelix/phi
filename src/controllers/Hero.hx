package controllers;

import actions.Action;
import actions.InteractAction;
import archetypes.Actor;
import hxd.Key;
import actions.WalkAction;

class Hero implements Controller {
  public var type = 'hero';
  public var self: Actor;

  private static var keyMap = [
    Key.F, // 0
    Key.D, // 1
    Key.S, // 2
    Key.A, // 3
    Key.W, // 4
    Key.E, // 5
  ];

  public function new () {}

  public function getAction (): Action {

    // movement 
    for (k in 0...6) {
      if (Key.isPressed(keyMap[k])) {
        return new WalkAction(self, k);
      }
    }

    var structure = Manager.inst.map.at(self.transform.pos).structure;
    if (structure != null) {
      if (Key.isPressed(Key.R)) {
        return new InteractAction(self, structure);
      }
    }

    return null;
  }
}