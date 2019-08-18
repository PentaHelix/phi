package rules;

import motion.Actuate;
import phi.Universe;
import h2d.TileGroup;
import phi.Game;
import ds.VecMap;
import haxe.ds.IntMap;
import hxd.Res;
import h2d.Bitmap;
import h2d.Tile;
import phi.Entity;
import phi.Rule;

import traits.HexTransform;
import traits.HexActor;

typedef Actor = {
  @:trait var transform: HexTransform;
  @:trait var actor: HexActor;
  var ?sprite: Bitmap;
}

class HexActorRule implements Rule<Actor> {
  public static var actors: Array<Array<Tile>>;
  var current: Int = 0;
  var order: Array<Entity> = new Array<Entity>();

  var fog: Tile;
  var fogGroup: TileGroup;
  var mapKnowledge: IntMap<VecMap<Bool>>;

  public function new () {
    actors = Res.load("actors.png")
      .toTile()
      .grid(16)
      .map(arr -> arr.map(s -> s.center()));
    
    mapKnowledge = new IntMap<VecMap<Bool>>();
    fogGroup = new TileGroup(Res.load("fog.png").toTile(), null);
    fog = Res.load("fog.png").toTile().center();
  }

  var didFog: Bool = false;
  var waiting: Bool = true;

  public function tick () {
    if (order.length == 0) return;
    // current %= order.length;
    var actor = entities.get(order[current]).actor;
    var sprite = entities.get(order[current]).sprite;
    
    if (waiting && !didFog) {
      revealMap();
      setFog();
      didFog = true;
    }

    if (actor.energy + actor.speed >= 100) {
      var action = actor.controller.getAction();
      waiting = action == null;
      if (action != null) {
        didFog = false;
        var success = action.perform();
        if (success) {
          actor.energy -= 100 - actor.speed;
          revealMap();
          sprite.tile = actors[actor.actorId][spriteFacing[actor.facing]];
          current = (current + 1) % order.length;
        }
      }
    } else {
      actor.energy += actor.speed;
      current = (current + 1) % order.length;
    }
  }

  public function onMatched (a: Actor, e: Entity) {
    Manager.inst.map.at(a.transform.pos).actor = a;
    a.sprite = new Bitmap(actors[a.actor.actorId][0]);
    Game.universe.root.add(a.sprite, 1);
    a.actor.controller.self = a;
    order.push(e);
    if (mapKnowledge.get(e) == null) {
      mapKnowledge.set(e, new VecMap<Bool>());
    }
  }

  public function onUnmatched (a: Actor, e: Entity) {
    trace(e);
    order.remove(e);
    a.sprite.remove();
  }

  public function onWarp (u: Universe) {
    u.root.add(fogGroup, 10);
  }

  public function getNearestNonHostile (pos: HexVec): Actor {
    var nearest: Actor = null;
    var minDist = 100000;
    for (e in entities) {
      if (e.actor.controller.type == 'hostile') continue;
      var d = Hex.distance(pos, e.transform.pos);
      if (d < minDist) {
        nearest = e;
        minDist = d;
      }
    }
    
    return nearest;
  }

  var visible: VecMap<Bool>;
  private function revealMap () {
    visible = new VecMap<Bool>();
    var e = entities.get(order[current]);
    var actor = e.actor;
    var transform = e.transform;
    for (hex in Hex.range(actor.perception)) {
      if (Manager.inst.map.isVisibleFrom(transform.pos, transform.pos + hex)) {
        mapKnowledge.get(order[current])[transform.pos + hex] = true;
        visible[transform.pos + hex] = true;
      }
    }
  }

  private function setFog () {
    fogGroup.clear();
    for (hex in Hex.range(Manager.inst.map.radius)) {
      var actor = Manager.inst.map.at(hex).actor;
      if (mapKnowledge.get(order[current])[hex] == true && visible[hex] == true) {
        if (actor != null) Actuate.tween(actor.sprite, 0.3, {alpha: 1});
        continue;
      }
      if (actor != null) Actuate.tween(actor.sprite, 0.3, {alpha: 0});
      var p = hex.toPixel();
      if (mapKnowledge.get(order[current])[hex] == true) {
        fogGroup.addAlpha(p.x, p.y, 0.5, fog);
      } else {
        fogGroup.add(p.x, p.y, fog);
      }
    }
  }

  private static var spriteFacing = [
    0,
    1,1,
    2,
    3,3
  ];
}