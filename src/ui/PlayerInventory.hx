package ui;

import hxd.Event;
import h2d.Interactive;
import h3d.Vector;
import h2d.Tile;
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
    new Vector(16, 23),
    new Vector(32, 23),
    new Vector(48, 23),
    new Vector(64, 23),
    new Vector(80, 23),
    new Vector(96, 23),
    new Vector(112, 23),
    new Vector(128, 23),
  ];
  
  public function new () {
    super();
    inventory = new Inventory(25);
    bmp = new Bitmap(Res.load('ui.png').toTile().sub(0, 0, 144, 57), this);
    y = 0;
  }

  override public function onAdd () {
    super.onAdd();
    var scene = this.getScene();
    bmp.x = -scene.width/2;
    bmp.y = scene.height/2 - 16;
    addItem(new Item("potion_of_healing"));
    addItem(new Item("potion_of_poison"));
    addItem(new Item("potion_of_healing"));
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
    //   var iBmp = new Bitmap(itemTiles[item.id]);
    //   itemBitmaps.push(iBmp);
    //   iBmp.x = slots[pos].x;
    //   iBmp.y = slots[pos].y;
    //   bmp.addChild(iBmp);

    //   var interact = new Interactive(14, 14, iBmp);
    //   interact.x = -7;
    //   interact.y = -7;

    //   var initialX: Float = iBmp.x;
    //   var initialY: Float = iBmp.y;
    //   var dragPos: Vector;
    //   var droppedSlot: Int = -1;

    //   interact.onPush = function (ev) {
    //     initialX = iBmp.x;
    //     initialY = iBmp.y;
    //     dragPos = new Vector(initialX, initialY);
    //     var offsetX: Float = ev.relX;
    //     var offsetY: Float = ev.relY;
    //     interact.startDrag(function (ev) {
    //       dragPos.x += ev.relX - offsetX;
    //       dragPos.y += ev.relY - offsetY;

    //       iBmp.x = dragPos.x;
    //       iBmp.y = dragPos.y;

    //       droppedSlot = -1;
    //       for (i in 0...slots.length) {
    //         if (slots[i].distance(dragPos) < 4) {
    //           droppedSlot = i;
    //           iBmp.x = slots[i].x;
    //           iBmp.y = slots[i].y;
    //           dragPos.x = slots[i].x;
    //           dragPos.y = slots[i].y;
    //           break;
    //         }
    //       }
    //     });
    //   };

    //   interact.onRelease = function (ev) {
    //     if (droppedSlot != -1) {
    //       inventory.move(item, droppedSlot);
    //       iBmp.x = slots[droppedSlot].x;
    //       iBmp.y = slots[droppedSlot].y;
    //     } else {
    //       iBmp.x = initialX;
    //       iBmp.y = initialY;
    //     }

    //     interact.stopDrag();
    //   };
    }
  }
}