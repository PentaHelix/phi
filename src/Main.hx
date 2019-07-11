package;

import h3d.Vector;
import hxd.Event;
import hxd.Key;
import phi.Entity;
import phi.Game;
import phi.Universe;

using Hex;
using Utils;

class Main extends Game {
  var universe: Universe;

  var entities:Array<Entity> = [];

  public static function main() {
    hxd.Res.initEmbed();
    C.init();
    new Main();
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

    Game.warpTo(universe);

    var map = new HexMap(14);
    
    for (s in HexVec.offsets.concat([HexVec.ZERO])) {
      var room = gen.Dungeon.room().map(p -> p + s*8);
      map.fill(room, 1);
      map.set(room.outline(), 2);
    }

    new Entity([
      new HexTransform(HexVec.ZERO),
      new HexActor(0, null)
    ], universe);
    map.createTiles(universe);
  }

  var hexes: Array<HexVec> = [HexVec.ZERO];

  override public function tick () {
    super.tick();
  }
}