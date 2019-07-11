package;

import ds.PriorityQueue;
import traits.HexTile;
import h3d.Vector;
import hxd.Event;
import hxd.Key;
import phi.Entity;
import phi.Universe;

import rules.HexMapRule;
import rules.HexActorRule;
import traits.HexTransform;
import traits.HexActor;

using Hex;

class Game extends phi.Game {
  var universe: Universe;
  var map: HexMap;

  public static function main() {
    hxd.Res.initEmbed();
    C.init();
    new Game();
  }
  
  override public function init () {
    s2d.zoom = 8;
    s2d.x = 85 * 8/s2d.zoom;
    s2d.y = 45 * 8/s2d.zoom;

    universe = new Universe();
    var pass = new phi.Pass();

    universe.addPass(pass);

    pass.add(new HexMapRule(s2d));
    pass.add(new HexActorRule(s2d));

    phi.Game.warpTo(universe);

    map = new HexMap(14);
    
    for (s in HexVec.offsets.concat([HexVec.ZERO])) {
      var room = gen.Dungeon.room().map(p -> p + s*8);
      map.fill(room, "floor_rocks");
      map.set(room.outline(), "wall_bricks");
    }

    new Entity([
      new HexTransform(HexVec.ZERO),
      new HexActor(1, null)
    ], universe);

    var path = map.findPath(new HexVec(0,0,0), new HexVec(2, -2, 0));
    trace(path);
    if (path != null) {
      map.set(path, "floor_planks");
    }

    map.createTiles(universe);
  }

  var hexes: Array<HexVec> = [HexVec.ZERO];

  override public function tick () {
    super.tick();
  }
}