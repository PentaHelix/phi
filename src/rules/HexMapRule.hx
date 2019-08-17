package rules;

import phi.Universe;
import h2d.Tile;
import hxd.Res;
import h2d.TileGroup;
import phi.Rule;
import phi.Entity;

import traits.HexTransform;
import traits.HexTile;

typedef Tiles = {
  @:trait var transform: HexTransform;
  @:trait var tile: HexTile;
}

class HexMapRule implements Rule<Tiles> {
  var group: TileGroup;
  var tiles: Array<Tile> = [];

  public function new () {
    var tileMap = Res.load("tiles.png").toTile();
    group = new TileGroup(tileMap, null);

    tiles = [
			 for(x in 0 ... C.TILE_COUNT)
			 for(y in 0 ... 1)
			 tileMap.sub(x * 16, y * 16, 16, 16).center()
		];
  }

  public function onWarp (u: Universe) {
    u.s2d.addChildAt(group, 0);
  }

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