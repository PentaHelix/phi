package ui;

import h2d.Scene;
import h3d.Vector;
import items.Item;
import hxd.Res;
import h2d.Bitmap;
import h2d.Object;
import items.Inventory;

class PlayerInventory extends Object {
  private var inventory: Inventory;
  public var bmp: Bitmap;
  private var itemBitmaps: Array<InventoryItem> = [];

  private var slots: Array<Vector> = [
    for (y in 0...3)
      for (x in 0...9) 
        new Vector(x*15 + 8, 38-y*15)
  ];
  
  public function new () {
    super();
    inventory = new Inventory(27);
    bmp = new Bitmap(Res.load('ui.png').toTile().sub(0, 0, 136, 63), this);
    y = 0;

    for (i in 0...27) {
      if (i % 2 == 0) addItem(new Item("potion_of_healing"));
      else addItem(new Item("potion_of_poison"));
    }
  }

  public function addItem(item: Item) {
    var pos = inventory.add(item);
    if (pos == -1) {
      // TODO
    } else {
      var invItem = new InventoryItem(item, inventory, slots);
      invItem.x = slots[pos].x;
      invItem.y = slots[pos].y;
      bmp.addChild(invItem);
      itemBitmaps.push(invItem);
    }
  }

  public function onResize (s2d: Scene) {
    bmp.x = s2d.width/2/UI.uiScale - 136*UI.uiScale;
    bmp.y = -s2d.height/2/UI.uiScale - 47;
  }
}