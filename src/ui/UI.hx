package ui;

import motion.easing.Bounce;
import motion.Actuate;
import hxd.Key;
import h2d.Object;

class UI extends Object {
  private static var inst: UI;

  private static var log: Log;
  private static var playerInventory: PlayerInventory;

  private static var state: Array<State> = [DEFAULT];
  private function new () {
    super();
    log = new Log();
    playerInventory = new PlayerInventory();

    addChild(log);
    addChild(playerInventory);
  }

  public static function get () {
    if (inst == null) inst = new UI();
    return inst;
  }

  public static function tick () {
    var s = state[state.length - 1];
    if (s != DEFAULT) {
      if (Key.isPressed(Key.ESCAPE)) {
        popState();
      }
    }

    switch (s) {
      case DEFAULT:
        if (Key.isPressed(Key.I)) {
          pushState(PLAYER_INVENTORY);
        }
      default:
    }
  }

  private static function pushState (s: State) {
    state.push(s);
    switch (s) {
      case PLAYER_INVENTORY:
        tween(playerInventory, 0.3, {
          y: -41,
        }).ease(Bounce.easeOut).snapping();
      default:
    }
  }

  private static function popState () {
    switch (state.pop()) {
      case PLAYER_INVENTORY:
        tween(playerInventory, 0.3, {
          y: 0
        }).ease(Bounce.easeOut).snapping();
      default:
    }
  }

  private static function tween (target, duration, properties) {
    return Actuate.tween(target, duration, properties).onUpdate(() -> {inst.posChanged = true;});
  }
}

enum State {
  DEFAULT;
  PLAYER_INVENTORY;
}