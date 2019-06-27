package;

class Main extends phi.Game {
  public static function main() {
    new Main();
  }

  override public function init () {
    var pass = new phi.Pass();
    pass.add(new HexMapRule());
    pass.tick();
  }

  override public function update (dt: Float) {

  }
}