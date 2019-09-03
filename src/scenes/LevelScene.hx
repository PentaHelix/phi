package scenes;

import h2d.Object;
import h2d.Scene;

class LevelScene extends Scene {
  public function new () {
    super();
    var zoom = 4;
    scaleMode = Zoom(zoom);
    x = 85 * 8/zoom;
    y = 45 * 8/zoom;
    x = width / 2;
    y = height / 2;

    addChildAt(ui.UI.get(), 1);
  }
}