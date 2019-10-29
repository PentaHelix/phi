package rules;

import h2d.Object;
import phi.Universe;
import h2d.Tile;
import hxd.Res;
import h2d.TileGroup;
import phi.Rule;
import phi.Entity;

import traits.HexTransform;
import traits.HexTile;

typedef Map = {
  @:trait 
  var tiles: traits.HexMap;
}

class HexMapRule implements Rule<Map> {
  var tileGroup: TileGroup;
  var tiles: Array<Tile> = [];

  public function new () {
    var tileMap = Res.load("tiles.png").toTile();
    tileGroup = new TileGroup(tileMap, null);

    tiles = [
			 for(x in 0 ... C.TILE_COUNT)
			 for(y in 0 ... 1)
			 tileMap.sub(x * 16, y * 16, 16, 16).center()
		];
  }

  public function onWarp (u: Universe) {
    u.root.add(tileGroup, 0);
    // new Object().
  }

  public function tick () {
    trace(entities);
  }

  public function onMatched (m: Map, e: Entity) {
    // makeTile(t);
    trace(m);
  }

  // public function onUnmatched (m: Map, e: Entity) {
  //   tileGroup.clear();
  //   for (t in entities) {
  //     makeTile(t);
  //   }
  // }

  // private function makeTile (t:Tiles) {
  //   var pos = t.transform.pos.toPixel();
  //   tileGroup.add(pos.x, pos.y, tiles[t.tile.tileId]);
  // }
}