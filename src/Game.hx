package;

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
    s2d.zoom = 3;
    s2d.x = 85 * 8/s2d.zoom;
    s2d.y = 45 * 8/s2d.zoom;

    universe = new Universe();
    var pass = new phi.Pass();

    universe.addPass(pass);

    pass.add(new HexMapRule(s2d));
    pass.add(new HexActorRule(s2d));

    phi.Game.warpTo(universe);

    map = new HexMap(18);
    
    var doorways: Array<HexVec> = [];
    var rooms: Array<HexVec> = [];

    for (s in HexVec.offsets.concat([HexVec.ZERO])) {
      var room = gen.Dungeon.room().map(p -> p + s*11);
      map.fill(room, "floor_rocks");
      var outline = room.outline();

      rooms = rooms.concat(room).concat(outline);
      
      for (i in 0...4) {
        var idx: Int = Math.floor(outline.length/4) * i;
        doorways.push(outline[idx]);
      }
      map.set(room.outline(), "wall_bricks");
    }


    var maze = gen.Dungeon.maze(doorways, rooms, 18);

    map.set(maze, "floor_planks");
    map.set(doorways, "wall_bricks_doorway");

    // map.set(map.findPath(HexVec.offsets[0]*11, HexVec.offsets[1]*11), "wall_bricks");

    new Entity([
      new HexTransform(HexVec.ZERO),
      new HexActor(1, null)
    ], universe);

    map.createTiles(universe);
  }

  var hexes: Array<HexVec> = [HexVec.ZERO];

  override public function tick () {
    super.tick();
  }
}