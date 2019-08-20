package scenes;

import h2d.Object;
import h2d.Scene;
import ui.Log;

class LevelScene extends Scene {

  public function new () {
    super();
    var zoom = 4;
    scaleMode = Zoom(zoom);
    x = 85 * 8/zoom;
    y = 45 * 8/zoom;

    makeUI();
  }

  private function makeUI () {
    var ui = new Object(this);
    addChildAt(ui, 1);

    ui.addChild(Log.get());
  }
}