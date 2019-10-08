package ui;

import h2d.Tile;
import h2d.Bitmap;
import h2d.Scene;
import motion.easing.Bounce;
import motion.Actuate;
import hxd.Key;
import h2d.Object;

class UI extends Object {
  public static var uiScale: Float = 1;
  private static var inst: UI;

  private static var topBar: Bitmap;
  private static var log: Log;
  private static var playerInventory: PlayerInventory;
  private static var playerInfo: PlayerInfo;
  private static var itemInfo: ItemInfo;

  private static var state: Array<State> = [DEFAULT];
  private function new () {
    super();
    topBar = new Bitmap(Tile.fromColor(0x1c121c, 1600, 1));
    log = new Log();
    playerInventory = new PlayerInventory();
    playerInfo = new PlayerInfo();
    itemInfo = new ItemInfo();

    addChild(topBar);
    addChild(log);
    addChild(playerInventory);
    addChild(playerInfo);
    // addChild(itemInfo);
  }

  public function onResize(s2d: Scene) {
    uiScale = s2d.width / 350;
    uiScale = Math.floor(uiScale / 0.25) * 0.25;
    scaleX = scaleY = uiScale;
    topBar.x = -s2d.width/2/uiScale;
    topBar.y = -s2d.height/2/uiScale;
    log.onResize(s2d);
    playerInventory.onResize(s2d);
    playerInfo.onResize(s2d);
    // itemInfo.onResize(s2d);
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
          y: 47,
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