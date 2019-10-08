package scenes;

import h2d.Scene;

class LevelScene extends Scene implements util.Resizable {
  public function new () {
    super();
    scaleMode = Zoom(4);
    addChildAt(ui.UI.get(), 1);
  }

  public function onResize (s2d: Scene) {
    x = width / 2;
    y = height / 2;
  } 
}