package ui;

import h2d.Scene;
import hxd.Res;
import h2d.Object;
import h2d.Bitmap;

class PlayerInfo extends Object {
  var bmp: Bitmap;
  override public function new () {
    super();
    bmp = new Bitmap(Res.load('ui.png').toTile().sub(136, 0, 63, 16), this);
  }

  public function onResize (s2d: Scene) {
    this.x = -s2d.width/2/UI.uiScale;
    this.y = -s2d.height/2/UI.uiScale;
  }
}