package scenes;

import h2d.Object;
import h2d.Scene;
import ui.Log;

class LevelScene extends Scene {
  private static var ui: Object;
  public function new () {
    super();
    var zoom = 4;
    scaleMode = Zoom(zoom);
    x = 85 * 8/zoom;
    y = 45 * 8/zoom;
    x = width / 2;
    y = height / 2;

    makeUI();
  }

  private function makeUI () {
    if (ui == null) {
      ui = new Object(this);
      ui.addChild(new Log());
      ui.addChild(new ui.PlayerInventory());
    }

    addChildAt(ui, 1);
  }
}