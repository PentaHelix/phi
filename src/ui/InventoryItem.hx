package ui;

import hxd.Res;
import items.Item;
import hxd.Event;
import h2d.Interactive;
import items.Inventory;
import h2d.Bitmap;
import h3d.Vector;

class InventoryItem extends Bitmap {
  private var item: Item;
  private var inventory: Inventory;

  private var initialX: Float;
  private var initialY: Float;
  private var dragPos: Vector;
  private var droppedSlot: Int = -1;

  private var inter: Interactive;

  private var slots: Array<Vector>;

  public function new (item: Item, inventory: Inventory, slots: Array<Vector>) {
    var tile = Res.load("items.png").toTile().sub(item.id * 16, 0, 16, 16).center();
    super(tile);
    this.item = item;
    this.inventory = inventory;
    this.slots = slots;

    inter = new Interactive(14, 14, this);
    inter.x = -7;
    inter.y = -7;

    initialX = x;
    initialY = y;

    inter.onPush = onPush;
    inter.onRelease = onRelease;
    inter.onOver = onOver;
  }

  private function onPush (ev: Event) {
    initialX = x;
    initialY = y;
    dragPos = new Vector(initialX, initialY);
    var offsetX: Float = ev.relX;
    var offsetY: Float = ev.relY;
    inter.startDrag(function (ev) {
      dragPos.x += ev.relX - offsetX;
      dragPos.y += ev.relY - offsetY;

      x = dragPos.x;
      y = dragPos.y;

      droppedSlot = -1;
      for (i in 0...slots.length) {
        if (slots[i].distance(dragPos) < 4) {
          var it = inventory.get(i);
          if (it != null && it != item) continue;
          droppedSlot = i;
          x = slots[i].x;
          y = slots[i].y;
          dragPos.x = slots[i].x;
          dragPos.y = slots[i].y;
          break;
        }
      }
    });
  }

  private function onRelease (ev: Event) {
    if (droppedSlot != -1) {
      inventory.move(item, droppedSlot);
      x = slots[droppedSlot].x;
      y = slots[droppedSlot].y;
    } else {
      x = initialX;
      y = initialY;
    }

    inter.stopDrag();
  }
  
  private function onOver (ev: Event) {
    // ItemInfo.display(this);
  }
} 