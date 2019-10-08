package gen;

import C.LevelData;
import HexMap.PathNode;
import ds.PriorityQueue;
import ds.VecMap;
import structureTypes.Door;
import structureTypes.Ladder;
import structureTypes.Furniture;

using Hex;
using Utils;
using Lambda;

typedef Room = {
  var name: String;
  var floor: Array<HexVec>;
  var walls: Array<HexVec>;
}

class Fortress {
  public static inline var ROOM_MIN_SIZE = 8;
  public static inline var ROOM_MAX_SIZE = 20;

  public static function make (map: HexMap, data: LevelData): HexMap {
    var corridors = getCorridors();
    var possibleDoorways: Array<HexVec> = [];
    var freeSpace: PriorityQueue<HexVec> = new PriorityQueue<HexVec>();

    var roomPositions:Array<HexVec> = HexVec.offsets.copy();
    var rooms: VecMap<Room> = new VecMap<Room>();

    for (r in data.rooms) {
      if (r.chance != null && Math.random() > r.chance) continue;
      if (Math.random() > r.chance) continue;

      var pos = roomPositions.popRandom();
      var room = room(pos*13);
      room.name = r.name;
      rooms[pos] = room;
    }


    var obstacles: Array<HexVec> = [];
    for (s in HexVec.offsets.concat([HexVec.ZERO])) {
      var room = rooms[s];
      if (room == null) {
        rooms[s] = gen.Fortress.room(s*13);
        room = rooms[s];
      }

      var type = C.roomTypes.get(room.name);
      
      map.fill(room.floor, type.floor);
      map.set(room.walls, type.walls);

      obstacles = obstacles.concat(room.floor).concat(room.walls);
      
      for (i in 0...6) {
        var idx: Int = Math.floor(room.walls.length*i/6);
        possibleDoorways.push(room.walls[idx]);
      }
    }

    var maze = gen.Fortress.maze(possibleDoorways, obstacles, 18);
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
      var corridor = gen.Fortress.corridor(obstacles, maze, possibleDoorways[d1], possibleDoorways[d2]);
      doorways.push(possibleDoorways[d1]);
      doorways.push(possibleDoorways[d2]);
      map.set(corridor.slice(1, -1), 'floor_planks');
      map.fill(corridor.slice(1, -1).outline(), 'wall_bricks');
    }

    Builder.commitTiles();

    for (r in rooms) {
      var type = C.roomTypes.get(r.name);
      
      for (s in type.structures) {
        if (s.amount != null) {
          var amount = s.amount.roll();
          for (_ in 0...amount) {
            Builder.structure(r.floor.popRandom(), s.name, Type.createInstance(s.type, [s.data]));
          }
        } else {
          if (s.chance != null && s.chance < Math.random()) continue;
          Builder.structure(r.floor.popRandom(), s.name, Type.createInstance(s.type, [s.data]));
        }
      }

      var i = 0;
      for (space in r.floor.shuffle()) {
        freeSpace.enqueue(space, i++);
      }
    }

    for (d in doorways) Builder.structure(d, "door", new Door());

    for (s in data.structures) {
      if (s.amount != null) {
        var amount = s.amount.roll();
        for (_ in 0...amount) {
          Builder.structure(freeSpace.dequeue(), s.name, Type.createInstance(s.type, [s.data]));
        }
      } else {
        if (s.chance != null && s.chance < Math.random()) continue;
        Builder.structure(freeSpace.dequeue(), s.name, Type.createInstance(s.type, [s.data]));
      }
    }

    Builder.hero(HexVec.ZERO);
    var rat = Builder.actor(HexVec.offsets[0] * 2, "rat", new controllers.Hostile());

    return map;
  }

  private static function room (pos: HexVec): Room {
    var hexes = [HexVec.ZERO];

    while (hexes.length < ROOM_MIN_SIZE || Math.random() > hexes.length / ROOM_MAX_SIZE) {
      var outline = hexes.outline();

      hexes.push(outline.random());
      outline = hexes.outline();
    
      hexes = hexes.concat(outline);
    }

    return {
      name: 'fortress_default',
      floor: hexes.map(p -> p + pos),
      walls: hexes.outline().map(p -> p + pos)
    };
  }

  private static function maze (initialPassages: Array<HexVec>, initialWalls: Array<HexVec>, size: Int) {
    var passages: VecMap<Bool> = new VecMap<Bool>();
    var walls: VecMap<Bool> = new VecMap<Bool>();
    var open: Array<HexVec> = initialPassages.copy();

    for (p in initialPassages) {
      open.push(p);
    }

    for (w in initialWalls) {
      walls[w] = true;
    }

    while (open.length != 0) {
      var h = open.random();
      open.remove(h);

      var count = h.neighbors().count(n -> passages[n.serialize()]);
      if (count > 2) continue;

      var last = passages[h.neighbors()[5]];
      var shouldOpen = true;
      for (n in h.neighbors()) {
        if (last && passages[n]) shouldOpen = false;
        last =  passages[n];
      }

      if (shouldOpen) {
        passages[h] = true;
        walls[h] = false;
      } else {
        walls[h] = true;
        passages[h] = true;
      }

      for (n in h.neighbors()) {
        if (passages[n]) continue;
        if (walls[n]) continue;
        if (Hex.distance(HexVec.ZERO, n) >= 18) continue;

        open.push(n);
      }
    }
    
    return passages;
  }

  private static function corridor (w: Array<HexVec>, maze: VecMap<Bool>, p1: HexVec, p2: HexVec) {
    var explored: VecMap<PathNode> = new VecMap<PathNode>();
    var queue:PriorityQueue<PathNode> = new PriorityQueue<PathNode>();
    var dist = Hex.distance(p1, p2);

    var walls: VecMap<Bool> = new VecMap<Bool>();
    for (wall in w) {
      walls[wall] = true;
    }

    queue.enqueue({
      pos: p1,
      prev: null,
      g: 0,
      h: dist,
      f: dist
    }, dist);

    var found: Bool = false;
    var current:PathNode = null;

    while (!queue.isEmpty() && !found) {
      current = queue.dequeue();
      explored[current.pos] = current;

      if (current.pos == p2) {
        found = true;
        break;
      }

      for (n in current.pos.neighbors()) {
        if(walls[n] == true && n != p2) continue;

        var gScore:Float = current.g + 1;
        var fScore:Float = gScore + Hex.distance(n, p2);

        if (maze[n]) fScore /= 2;

        var ex:PathNode = explored[n];

        if (ex != null && fScore >= ex.f) {
          continue;
        } else if (!queue.contains(ex) || fScore < ex.f) {
          if (ex == null) {
            ex = {
              pos: n,
              prev: null,
              g: 0,
              h: Hex.distance(n, p2),
              f: 0,
            }
          }
          if (ex.pos == p1) continue;
          ex.prev = current;
          ex.g = gScore;
          ex.f = fScore;

          if (queue.contains(ex)) {
            queue.remove(ex);
          }

          queue.enqueue(ex, ex.f);
        }
      }
    }

    if (!found) return null;
    var n: PathNode = current;
    var path = [];
    do {
      path.unshift(n.pos);
    } while ((n = n.prev) != null);

    return path;
  }

  private static function getCorridors () {
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

    return corridors;
  }
}

typedef MazeNode = {
  var pos: HexVec;
  var prev: MazeNode;
}