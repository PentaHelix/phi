package;

import h3d.Vector;
import hxd.Event;
import hxd.Key;
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

    (new HexPos(0, -3, 3)).neighbors(true).map(p -> {
      trace('$p -> ${HexPos.deserialize(p.serialize())}');
    });

    Game.warpTo(universe);
    s2d.x = 85;
    s2d.y = 45;
  }

  var entities:Array<Entity> = [];

  override public function tick () {
    super.tick();
  
    if (Key.isPressed(Key.SPACE)) {
      for (e in entities) e.destroy();
      var room: Array<HexPos> = [new HexPos(0,0,0)];
      while (Math.random() > room.length / 20) {
        
        if (Math.random() < 0.5) {

        } else {

        }
      }
    }
  }
}