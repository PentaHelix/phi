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
}

class HexActorRule implements Rule<Actor> {
  var actors: Array<Tile>;
  var s2d: Scene;
  public function new (s: Scene) {
    s2d = s;
    actors = Res.load("actors.png")
      .toTile()
      .gridFlatten(16)
      .map(s -> s.center());
  }

  public function tick () {
    for (a in entities) {
      move(a);
      var pos = a.transform.pos.toPixel();
      a.sprite.setPosition(pos.x, pos.y);
    }
  }

  private function move (a: Actor) {
    if (Key.isPressed(Key.F)) {
      a.transform.pos += HexPos.offsets[0];
    } else if (Key.isPressed(Key.D)) {
      a.transform.pos += HexPos.offsets[1];
    } else if (Key.isPressed(Key.S)) {
      a.transform.pos += HexPos.offsets[2];
    } else if (Key.isPressed(Key.A)) {
      a.transform.pos += HexPos.offsets[3];
    } else if (Key.isPressed(Key.W)) {
      a.transform.pos += HexPos.offsets[4];
    } else if (Key.isPressed(Key.E)) {
      a.transform.pos += HexPos.offsets[5];
    }
  }

  public function onMatched (a: Actor) {
    a.sprite = new Bitmap(actors[0], s2d);
  }

  public function onUnmatched (a: Actor) {

  }
}