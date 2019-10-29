package traits;

import h2d.Layers;
import h2d.Bitmap;
import h3d.Vector;
import archetypes.Actor;
import haxe.ds.StringMap;
import ds.VecMap;
import phi.Trait;
import ds.PriorityQueue;

class HexMap {
  public var radius: Int;
  public var data: VecMap<MapData>;
  public var poi: StringMap<HexVec>;
  private var bitmaps: VecMap<Bitmap>;

  private var root: Layers;

  public function new (radius: Int, root: Layers) {
    this.radius = radius;
    this.data = new VecMap<MapData>();
    this.bitmaps = new VecMap<Bitmap>();
    this.poi = new StringMap<HexVec>();
    this.root = root;
  }

  public function at(v: HexVec) {
    if (this.data[v] == null) {
      this.data[v] = {
        tileId: 0,
        name: 'empty',
        passable: false,
        transparent: false,

        items: [],
        actor: null,
        structure: null
      };
    }

    return this.data[v];
  }

  public function set (area: Array<HexVec>, name: String) {
    for (p in area) {
      this.setTile(p, name);
    }
  }

  public function fill (area: Array<HexVec>, name: String) {
    for (p in area) {
      if (at(p).name == 'empty') this.setTile(p, name);
    }
  }

  public function setTile (at: HexVec, name: String) {
    if (this.bitmaps[at] != null) {
      this.bitmaps[at].remove();
    }
    var info = C.tiles.get(name);
    this.data[at] = {
      tileId: info.id,
      name: name,
      passable: info.passable,
      transparent: info.transparent,

      items: [],
      actor: null,
      structure: null
    }

    this.bitmaps[at] = new Bitmap(C.tileTex[info.id]);
    root.addChildAt(this.bitmaps[at], 0);
    var p = at.toPixel();
    this.bitmaps[at].x = p.x;
    this.bitmaps[at].y = p.y;
  }

  public function inBounds (hex: HexVec) {
    return Hex.distance(HexVec.ZERO, hex) <= radius;
  }

  public function findPath (p1: HexVec, p2: HexVec, ?maxLen=9999) {
    if(at(p1).name == 'empty' || at(p2).name == 'empty') return null;
    if(!at(p1).passable) return null;
    if(p1 == p2) return [];

    var explored: VecMap<PathNode> = new VecMap<PathNode>();
    var queue: PriorityQueue<PathNode> = new PriorityQueue<PathNode>();
    var dist = Hex.distance(p1, p2);

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
      if(at(current.pos).name == 'empty') continue;
      if(!at(current.pos).passable) continue;

      if (current.pos == p2) {
        found = true;
        break;
      }

      for (n in current.pos.neighbors()) {
        var gScore:Float = current.g + 1;
        var fScore:Float = gScore + Hex.distance(n, p2);
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

  public function isVisibleFrom (p1: Vector, p2: Vector, ?maxLength=-1): Bool {
    var dist = Hex.distance(p1, p2);
    if (maxLength > 0 && dist >= maxLength) return false;
    var lerp = (a: Float, b: Float, t: Float) -> a + (b - a) * t;
    for (i in 1...dist) {
      var t = i / dist;
      var dx = lerp(p1.x, p2.x, t);
      var dy = lerp(p1.y, p2.y, t);
      var dz = lerp(p1.z, p2.z, t);

      var h1 = null;
      var h2 = null;

      var xErr = Math.abs(Math.abs(dx % 1) - 0.5) < 0.01;
      var yErr = Math.abs(Math.abs(dy % 1) - 0.5) < 0.01;
      var zErr = Math.abs(Math.abs(dz % 1) - 0.5) < 0.01;

      if (xErr && yErr) {
        h1 = Hex.round(dx+0.5, dy-0.5, dz);
        h2 = Hex.round(dx-0.5, dy+0.5, dz);
      } else if (yErr && zErr) {
        h1 = Hex.round(dx, dy+0.5, dz-0.5);
        h2 = Hex.round(dx, dy-0.5, dz+0.5);
      } else if (xErr && zErr) {
        h1 = Hex.round(dx-0.5, dy, dz+0.5);
        h2 = Hex.round(dx+0.5, dy, dz-0.5);
      } else {
        h1 = Hex.round(dx, dy, dz);
      }
      var solid1 = at(h1).name == 'empty' || !at(h1).transparent;
      var solid2 = h2 == null || at(h2).name == 'empty' || !at(h2).transparent;
      if (solid1 && solid2) return false;
    }
    return true;
  }
}

typedef MapData = {
  var tileId: Int;
  var name: String;
  var passable: Bool;
  var transparent: Bool;

  var items: Array<String>;
  var actor: Actor;
  var structure: HexStructure;
}

typedef PathNode = {
  var pos: HexVec;
  var prev: PathNode;
  var f: Float;
  var g: Float;
  var h: Float;
}