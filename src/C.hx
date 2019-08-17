package;

import haxe.ds.StringMap;
import ds.DiceSet;

class C {
  public static var levelNames: Array<String> = [
    "Fortress 1",
    "Fortress 2",
    "Fortress 3",
    "Fortress 4",
    "Mines 1",
    "Mines 2",
    "Mines 3",
    "Mines 4"
  ];

  public static var tiles: StringMap<TileData> = new StringMap<TileData>();
  public static var actors: StringMap<ActorData> = new StringMap<ActorData>();
  public static var items: StringMap<ItemData> = new StringMap<ItemData>();
  public static var structures: StringMap<StructureData> = new StringMap<StructureData>();

  public static var TILE_COUNT:Int;
  public static var ACTOR_COUNT:Int;
  public static var ITEM_COUNT:Int;
  public static var STRUCTURE_COUNT:Int;

  public static function init () {
    var tileData:Array<TileData> = haxe.Json.parse(hxd.Res.load('data/tiles.json').entry.getText());
    TILE_COUNT = tileData.length;
    for (i in 0...tileData.length) {
      tiles.set(tileData[i].name, tileData[i]);
    }

    var actorData:Array<Dynamic> = haxe.Json.parse(hxd.Res.load('data/actors.json').entry.getText());
    ACTOR_COUNT = actorData.length;
    for (i in 0...actorData.length) {
      actorData[i].baseAttack = new DiceSet(actorData[i].baseAttack);
      actors.set(actorData[i].name, actorData[i]);
    }
    
    var itemData:Array<ItemData> = haxe.Json.parse(hxd.Res.load('data/items.json').entry.getText());
    ITEM_COUNT = itemData.length;
    for (i in 0...itemData.length) {
      items.set(itemData[i].name, itemData[i]);
    }

    var structureData:Array<Dynamic> = haxe.Json.parse(hxd.Res.load('data/structures.json').entry.getText());
    STRUCTURE_COUNT = structureData.length;
    for (i in 0...structureData.length) {
      if (structureData[i].states == null) {
        structureData[i].states = ['default'];
      }
      structures.set(structureData[i].name, structureData[i]);
    }
  }
}

typedef TileData = {
  var id: Int;
  var name: String;
  var variants: Array<Float>;
  var passable: Bool;
  var castsShadow: Bool;
}

typedef ActorData = {
  var id: Int;
  var name: String;
  var speed: Int;
  var baseAttack: DiceSet;
  var strength: Int;
  var perception: Int;
}

typedef ItemData = {
  var id: Int;
  var name: String;
  var equippable: Bool;
}

typedef StructureData = {
  var id: Int;
  var name: String;
  var states: Array<String>;
}