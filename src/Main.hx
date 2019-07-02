package;

import h3d.Vector;
import hxd.Event;
import hxd.Key;
import phi.Entity;
import phi.Game;
import phi.Universe;

using Hex;
using Utils;

class Main extends Game {
  var universe: Universe;

  var entities:Array<Entity> = [];

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
    s2d.x = 85;
    s2d.y = 45;
  }

  var hexes: Array<HexPos> = [HexPos.ZERO];

  override public function tick () {
    super.tick();
  
    if (Key.isPressed(Key.SPACE)) {
      for (e in entities) e.destroy();
      entities = [];
      

      for (hex in gen.Dungeon.room()) {
        var transform = new HexTransform();
        transform.pos = hex;
        entities.push(new Entity([
          transform,
          new HexTile()
        ], universe));
      }
    }
  }
}