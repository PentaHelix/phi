package ui;

import h2d.HtmlText;
import h3d.Vector;
import h2d.Bitmap;
import hxd.Res;
import items.Item;
import h2d.Object;

class ItemInfo extends Object {
  private static var inst: ItemInfo;
  private var bmp: Bitmap;
  private var text: HtmlText;

  public function new () {
    super();
    inst = this;
    var tile = Res.load('ui.png').toTile().sub(0, 56, 46, 77);
    bmp = new Bitmap(tile);
    addChild(bmp);

    text = new HtmlText(hxd.Res.font.pixel_font.toFont());
    addChild(text);
    text.text = "Restores around 15 health points plus an additional 10 for each level of the user.";
    text.dropShadow = {
      dx: 1/4,
      dy: 1/4,
      color: 0x000000,
      alpha: 0.8
    };
    text.x = 3;
    text.y = 11;
    text.maxWidth = 40;
    text.color = Vector.fromColor(0xffffffff);
    text.alpha = 1;
    text.letterSpacing = 1/4;
  }

  public static function display (item: InventoryItem) {
    inst.x = -16;
    inst.y = -70;
    item.addChild(inst);
    inst.posChanged = true;
  }
}