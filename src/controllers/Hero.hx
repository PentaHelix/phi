package controllers;

import traits.HexTransform;
import traits.HexActor;
import hxd.Key;
import actions.WalkAction;

class Hero implements Controller {
  var actor: HexActor;
  var transform: HexTransform;
  
  private static var keyMap = [
    Key.F, // 0
    Key.D, // 1
    Key.S, // 2
    Key.A, // 3
    Key.W, // 4
    Key.E, // 5
  ];

  public function new (actor: HexActor, transform: HexTransform) {
    this.actor = actor;
    this.transform = transform;
  }

  public function getAction () {
    for (k in 0...6) {
      if (Key.isPressed(keyMap[k])) {
        return new WalkAction(actor, transform, HexVec.offsets[k], k);
      }
    }
    return null;
  }
}