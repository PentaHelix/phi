package;

class C {
  public static var tiles: Array<TileData>;
  public static var actors: Array<ActorData>;
  public static function init () {
    tiles = haxe.Json.parse(hxd.Res.load('data/tiles.json').entry.getText());
    actors = haxe.Json.parse(hxd.Res.load('data/actors.json').entry.getText());
  }
}

typedef TileData = {
  var id: Int;
  var name: String;
  var variants: Array<Float>;
};

typedef ActorData = {
  var id: Int;
  var name: String;
}