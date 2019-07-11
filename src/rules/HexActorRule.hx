package rules;

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
  var ?facing: Int;
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
    // current %= entities.
    var actor = entities.get(current).actor;
    
    if (actor.energy + actor.speed >= 100) {
      actor.energy -= 100;

      var action = actor.controller.getAction();
      if (action == null) return;

      var success = action.perform();
      if (!success) return;
      
      actor.energy += actor.speed - 100;
      current++;
    }

    for (a in entities) {
      move(a);
      var pos = a.transform.pos.toPixel();
      a.sprite.x += (pos.x - a.sprite.x) * 0.3;
      a.sprite.y += (pos.y - 5 - a.sprite.y) * 0.3;
      // a.sprite.setPosition(pos.x, pos.y - 4);
      a.sprite.tile = actors[a.actor.actorId][spriteFacing[a.facing]];
    }
  }

  private static var spriteFacing = [
    0,
    1,1,
    2,
    3,3
  ];

  private static var keyMap = [
    Key.F, // 0
    Key.D, // 1
    Key.S, // 2
    Key.A, // 3
    Key.W, // 4
    Key.E, // 5
  ];

  private function move (a: Actor) {
    for (k in 0...6) {
      if (Key.isPressed(keyMap[k])) {
        a.transform.pos += HexVec.offsets[k];
        a.facing = k;
      }
    }
  }

  public function onMatched (a: Actor, e: Entity) {
    a.sprite = new Bitmap(actors[a.actor.actorId][0], s2d);
    order.add(e);
  }

  public function onUnmatched (a: Actor, e: Entity) {
    order.add(e);
  }
}