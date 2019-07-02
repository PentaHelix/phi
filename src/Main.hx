package;

import h3d.Vector;
import hxd.Event;
import hxd.Key;
import phi.Entity;
import phi.Game;
import phi.Universe;

using Hex;

class Main extends Game {
  var universe: Universe;
  var entities:Array<Entity> = [];
  var hexes: Array<HexPos> = [HexPos.ZERO];

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

    entities.push(new Entity([
      new HexTransform(),
      new HexTile()
    ], universe));

    Game.warpTo(universe);
    s2d.x = 85;
    s2d.y = 45;
  }

  override public function tick () {
    super.tick();
  
    if (Key.isPressed(Key.SPACE)) {
      for (e in entities) {
        e.destroy();
      }
      entities = [];

      hexes = hexes.outline();

      hexes.map(p -> {
        var transform = new HexTransform();
        transform.pos = p;
        entities.push(new Entity([
          transform,
          new HexTile()
        ], universe));
      });

      // for (e in entities) e.destroy();
      // var room: Array<HexPos> = [new HexPos(0,0,0)];
      // while (Math.random() > room.length / 20) {
        
      //   if (Math.random() < 0.5) {

      //   } else {

        // }
      // }
    }
  }
}