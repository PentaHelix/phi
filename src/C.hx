package;

import structureTypes.StructureType;
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
  public static var levels: StringMap<LevelData> = new StringMap<LevelData>();
  public static var roomTypes: StringMap<RoomTypeData> = new StringMap<RoomTypeData>();

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

    var levelData:Array<Dynamic> = haxe.Json.parse(hxd.Res.load('data/levels.json').entry.getText());
    for (data in levelData) {
      data.structures = data.structures == null ? [] : data.structures;

      data.structures = data.structures.map(mapStructureData);
      levels.set(data.name, data);
    }

    var roomTypeData:Array<Dynamic> = haxe.Json.parse(hxd.Res.load('data/rooms.json').entry.getText());
    for (data in roomTypeData) {
      data.structures = data.structures == null ? [] : data.structures;
      data.structures = data.structures.map(mapStructureData);
      roomTypes.set(data.name, data);
    }
  }

  private static function mapStructureData (s: Dynamic) {
    return {
      name: s.name,
      data: s.data == null ? [] : s.data,
      amount: s.amount == null ? new DiceSet("1") : new DiceSet(s.amount),
      type: Type.resolveClass("structureTypes." + s.type),
      chance: s.chance,
      poi: s.poi
    };
  }
}

typedef TileData = {
  var id: Int;
  var name: String;
  var variants: Array<Float>;
  var passable: Bool;
  var transparent: Bool;
}

typedef ActorData = {
  var id: Int;
  var name: String;
  var speed: Int;
  var baseAttack: DiceSet;
  var baseHealth: Int;
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

typedef LevelData = {
  var id: Int;
  var name: String;
  var generator: String;
  var rooms: Array<LevelRoomData>;
  var structures: Array<StructurePlacementData>;
}

typedef LevelRoomData = {
  var name: String;
  var chance: Null<Float>;
}

typedef RoomTypeData = {
  var id: Int;
  var name: String;
  var floor: String;
  var walls: String;
  var structures: Array<StructurePlacementData>;
}

typedef StructurePlacementData = {
  var name: String;
  var type: Class<StructureType>;
  var data: Dynamic;
  var chance: Null<Float>;
  var amount: DiceSet;
  var poi: String;
}