package rules;

import controllers.Passive;
import phi.Game;
import h2d.Scene;
import hxd.Res;
import h2d.Bitmap;
import h2d.Tile;
import hxd.Key;
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
  var actors: Array<Array<Tile>>;
  var s2d: Scene;
  var current: Int = 0;
  var order: List<Entity> = new List<Entity>();

  public function new (s: Scene) {
    s2d = s;
    actors = Res.load("actors.png")
      .toTile()
      .grid(16)
      .map(arr -> arr.map(s -> s.center()));
  }

  public function tick () {
    current %= order.length;
    var actor = entities.get(current).actor;
    
    if (actor.energy + actor.speed >= 100) {
      var action = actor.controller.getAction();
      if (action != null) {
        var success = action.perform();
        if (success) {
          actor.energy -= 100 - actor.speed;
          current++;
        }
      }
    } else {
      actor.energy += actor.speed;
    }

    for (a in entities) {
      var pos = a.transform.pos.toPixel();
      a.sprite.x += (pos.x - a.sprite.x) * 0.3;
      a.sprite.y += (pos.y - 5 - a.sprite.y) * 0.3;
      // a.sprite.setPosition(pos.x, pos.y - 4);
      a.sprite.tile = actors[a.actor.actorId][spriteFacing[a.actor.facing]];
    }
  }

  private static var spriteFacing = [
    0,
    1,1,
    2,
    3,3
  ];

  public function onMatched (a: Actor, e: Entity) {
    a.sprite = new Bitmap(actors[a.actor.actorId][0], s2d);
    a.actor.controller.self = a;
    order.add(e);
  }

  public function onUnmatched (a: Actor, e: Entity) {
    order.add(e);
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
}