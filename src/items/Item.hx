package items;

import archetypes.Actor;
import C.ItemData;
import haxe.ds.StringMap;

typedef ItemEvent = {
  var name: String;
  var user: Actor;
}

class Item {
  public var id: Int;
  public var name: String;
  public var level: Int = 0;
  public var identified: Bool = false;
  public var actions: StringMap<ItemEvent->Bool>;
  public var data: ItemData;
  public function new (name: String) {
    this.name = name;
    this.data = C.items.get(name);
    this.id = data.id;
  }
}