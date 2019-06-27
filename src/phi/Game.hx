package phi;

class Game extends hxd.App {
  public static var universe: Universe;
  public static var dt: Float;

  public function new () {
    super();
  }

  override public function update (dt: Float) {
    Game.dt = dt;
    universe.tick();
  }

  public static function warpTo (u: Universe) {
    Game.universe = u;
  }
}