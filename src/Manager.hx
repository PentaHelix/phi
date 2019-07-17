package;

import phi.Entity;
import phi.Universe;

import rules.HexMapRule;
import rules.HexActorRule;
import traits.HexTransform;
import traits.HexActor;

using Hex;
using Utils;

class Manager extends phi.Game {
  public static var map: HexMap;
  public static var actors: HexActorRule;
  var universe: Universe;


  public static function main() {
    hxd.Res.initEmbed();
    C.init();
    new Manager();
  }
  
  override public function init () {
    s2d.zoom = 1;
    s2d.x = 85 * 8/s2d.zoom;
    s2d.y = 45 * 8/s2d.zoom;

    universe = new Universe();
    var pass = new phi.Pass();

    universe.addPass(pass);

    pass.add(new HexMapRule(s2d));
    pass.add(new rules.TestRule());
    
    actors = new HexActorRule(s2d);
    pass.add(actors);

    phi.Game.warpTo(universe);

    var possibleCorridors = [
      {r1: 6, r2: 0}, {r1: 6, r2: 1}, 
      {r1: 6, r2: 2}, {r1: 6, r2: 3},
      {r1: 6, r2: 4}, {r1: 6, r2: 5},
      
      {r1: 0, r2: 1}, {r1: 1, r2: 2}, 
      {r1: 2, r2: 3}, {r1: 3, r2: 4},
      {r1: 4, r2: 5}, {r1: 5, r2: 0},
    ];

    var connected: Array<Int> = [6];
    var corridors = [];

    while(connected.length != 7) {
      var corr = possibleCorridors.filter(c -> corridors.indexOf(c) == -1).random();
      if (connected.indexOf(corr.r1) == -1) connected.push(corr.r1);
      else if (connected.indexOf(corr.r2) == -1) connected.push(corr.r2); 
      corridors.push(corr);
    }
    
    var possibleDoorways: Array<HexVec> = [];
    var rooms: Array<HexVec> = [];

    map = new HexMap(20);

    for (s in HexVec.offsets.concat([HexVec.ZERO])) {
      var room = gen.Dungeon.room().map(p -> p + s*13);
      map.fill(room, "floor_rocks");
      var outline = room.outline();

      rooms = rooms.concat(room).concat(outline);
      
      for (i in 0...6) {
        var idx: Int = Math.floor(outline.length*i/6);
        possibleDoorways.push(outline[idx]);
      }
      map.set(room.outline(), "wall_bricks");
    }

    var maze = gen.Dungeon.maze(possibleDoorways, rooms, 18);
    var doorways: Array<HexVec> = [];

    for (c in corridors) {
      var d1 = c.r1*6;
      var d2 = c.r2*6;
      var o1 = (c.r2 - (c.r1 - c.r2)) % 6;
      var o2 = (c.r1 - (c.r2 - c.r1)) % 6;
      if (c.r1 == 6) {
        o1 = c.r2;
        o2 = (-o2+3)%6;
      }

      if (o1 < 0) o1 += 6;
      if (o2 < 0) o2 += 6;
      d1 += o1;
      d2 += o2;
      var corridor = gen.Dungeon.corridor(rooms, maze, possibleDoorways[d1], possibleDoorways[d2]);
      doorways.push(possibleDoorways[d1]);
      doorways.push(possibleDoorways[d2]);
      map.set(corridor, "floor_planks");
    }
    map.set(doorways, "wall_bricks_doorway");
    hero = new HexTransform(HexVec.ZERO);
    new Entity([
      hero,
      new HexActor("hero", new controllers.Hero())
    ], universe);

    rat = new HexTransform(HexVec.offsets[0] * 2);
    new Entity([
      rat,
      new HexActor("rat", new controllers.Hostile())
    ], universe);

    map.createTiles(universe);
  }

  var hero: HexTransform;
  var rat: HexTransform;

  var hexes: Array<HexVec> = [HexVec.ZERO];

  override public function tick () {
    super.tick();
    trace(map.isVisibleFrom(hero.pos, rat.pos));
  }
}