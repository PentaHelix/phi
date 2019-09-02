package ui;

import h2d.RenderContext;
import hxd.Res;
import h2d.Bitmap;
import h2d.Object;
import items.Inventory;

class PlayerInventory extends Object {
  private var inventory: Inventory;
  private var bmp: Bitmap;
  public function new () {
    super();
    inventory = new Inventory(34);
    bmp = new Bitmap(Res.load('ui.png').toTile().sub(0, 0, 144, 57), this);
    bmp.x = 0;
    bmp.y = 0;
  }

  override public function sync (ctx: RenderContext) {
    this.x = -ctx.scene.width/2;
    this.y = -ctx.scene.height/2;
    bmp.x = 0;
    bmp.y = 0;
    bmp.y = ctx.scene.height - 16;
    trace(ctx.scene.height);  
  }
}