package rules;

import h2d.Tile;
import hxd.Res;
import h2d.TileGroup;
import h2d.Scene;
import phi.Rule;
import phi.Entity;

import traits.HexTransform;
import traits.HexTile;

typedef Tiles = {
  @:trait var transform: HexTransform;
  @:trait var tile: HexTile;
}

class HexMapRule implements Rule<Tiles> {
  var s2d: Scene;
  var group: TileGroup;
  var tiles: Array<Tile> = [];

  public function new (s2d: Scene) {
    this.s2d = s2d;
    var tileMap = Res.load("tiles.png").toTile();
    group = new TileGroup(tileMap, s2d);

    tiles = [
			 for(x in 0 ... C.TILE_COUNT)
			 for(y in 0 ... 1)
			 tileMap.sub(x * 16, y * 16, 16, 16).center()
		];
  }

  public function tick () {}

  public function onMatched (t: Tiles, e: Entity) {
    makeTile(t);
  }

  public function onUnmatched (e: Tiles, e: Entity) {
    group.clear();
    for (t in entities) {
      makeTile(t);
    }
  }

  private function makeTile (t:Tiles) {
    var pos = t.transform.pos.toPixel();
    group.add(pos.x, pos.y, tiles[t.tile.tileId]);
  }
}