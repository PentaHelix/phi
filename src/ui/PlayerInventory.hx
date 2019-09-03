package ui;

import hxd.Res;
import h2d.Bitmap;
import h2d.Object;
import items.Inventory;

class PlayerInventory extends Object {
  private var inventory: Inventory;
  public var bmp: Bitmap;
  
  public function new () {
    super();
    inventory = new Inventory(34);
    bmp = new Bitmap(Res.load('ui.png').toTile().sub(0, 0, 144, 57), this);
    y = 0;
  }

  override public function onAdd () {
    var scene = this.getScene();
    bmp.x = -scene.width/2;
    bmp.y = scene.height/2 - 16;
  }
}