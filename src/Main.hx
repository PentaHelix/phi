package;

import phi.Entity;
import phi.Game;
import phi.Universe;

class Main extends Game {
  var universe: Universe;
  public static function main() {
    hxd.Res.initEmbed();
    new Main();
  }

  override public function init () {
    s2d.zoom = 8;

    universe = new Universe();
    var pass = new phi.Pass();

    universe.addPass(pass);
    pass.add(new HexMapRule(s2d));

    Game.warpTo(universe);

    var pos = new HexPos(0, -3, 3);
    for (p in pos.neighbors(true)) {
      var transform = new HexTransform();
      transform.pos = p;
      new Entity([
        transform,
        new HexTile(),
      ], universe);
    }
  }

  override public function tick () {
    super.tick();
  }

}