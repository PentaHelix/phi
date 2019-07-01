package;

import h2d.Tile;
import hxd.Res;
import h2d.TileGroup;
import h2d.Scene;
import phi.Rule;
import phi.Entity;

typedef Tiles = {
  transform: HexTransform,
  tile: HexTile
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
			 for(y in 0 ... 1)
			 for(x in 0 ... 4)
			 tileMap.sub(x * 16, y * 16, 16, 16).center()
		];
  }

  public function tick () {
    
  }

  public function onMatched (e: Tiles) {
    var pos = e.transform.pos.toPixel();
    group.add(pos.x, pos.y, tiles[0]);
  }

  public function onUnmatched (e: Tiles) {
    trace('unmatched ${e}');
  }
}