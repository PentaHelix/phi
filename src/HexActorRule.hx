package;

import h2d.Scene;
import hxd.Res;
import h2d.Bitmap;
import h2d.Tile;
import hxd.Key;
import phi.Entity;
import phi.Rule;

typedef Actor = {
  @:trait var transform: HexTransform;
  @:trait var actor: HexActor;
  var ?sprite: Bitmap;
  var ?facing: Int;
}

class HexActorRule implements Rule<Actor> {
  var actors: Array<Array<Tile>>;
  var s2d: Scene;
  public function new (s: Scene) {
    s2d = s;
    actors = Res.load("actors.png")
      .toTile()
      .grid(16)
      .map(arr -> arr.map(s -> s.center()));
  }

  public function tick () {
    for (a in entities) {
      move(a);
      var pos = a.transform.pos.toPixel();
      a.sprite.setPosition(pos.x, pos.y);
      a.sprite.tile = actors[a.actor.actorId][a.facing];
    }
  }

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
        a.transform.pos += HexPos.offsets[k];
        a.facing = k;
      }
    }
  }

  public function onMatched (a: Actor) {
    a.sprite = new Bitmap(actors[a.actor.actorId][0], s2d);
  }

  public function onUnmatched (a: Actor) {

  }
}