package;

import haxe.ds.StringMap;

class C {
  public static var tiles: StringMap<TileData> = new StringMap<TileData>();
  public static var actors: StringMap<ActorData> = new StringMap<ActorData>();
  public static var items: StringMap<ItemData> = new StringMap<ItemData>();

  public static var TILE_COUNT:Int;
  public static var ACTOR_COUNT:Int;
  public static var ITEM_COUNT:Int;

  public static function init () {
    var tileData:Array<TileData> = haxe.Json.parse(hxd.Res.load('data/tiles.json').entry.getText());
    TILE_COUNT = tileData.length;
    for (i in 0...tileData.length) {
      tiles.set(tileData[i].name, tileData[i]);
    }

    var actorData:Array<ActorData> = haxe.Json.parse(hxd.Res.load('data/actors.json').entry.getText());
    ACTOR_COUNT = actorData.length;
    for (i in 0...actorData.length) {
      actors.set(actorData[i].name, actorData[i]);
    }
    
    var itemData:Array<ItemData> = haxe.Json.parse(hxd.Res.load('data/items.json').entry.getText());
    ITEM_COUNT = itemData.length;
    for (i in 0...itemData.length) {
      items.set(itemData[i].name, itemData[i]);
    }
  }
}

typedef TileData = {
  var id: Int;
  var name: String;
  var variants: Array<Float>;
  var passable: Bool;
}

typedef ActorData = {
  var id: Int;
  var name: String;
}

typedef ItemData = {
  var id: Int;
  var name: String;
  var equippable: Bool;
}