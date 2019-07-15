package controllers;

import rules.HexActorRule.Actor;
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

  public function getAction () {
    for (k in 0...6) {
      if (Key.isPressed(keyMap[k])) {
        return new WalkAction(self, k);
      }
    }
    return null;
  }
}