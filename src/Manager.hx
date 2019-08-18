package;

import motion.actuators.SimpleActuator;
import motion.Actuate;
import h2d.Scene;
import haxe.ds.StringMap;
import h3d.Engine;
import phi.Universe;

import rules.HexMapRule;
import rules.HexActorRule;
import traits.HexTransform;

class Manager extends phi.Game {
  // singleton
  public static var inst: Manager;
  
  public var map: HexMap;
  public var actors: HexActorRule;
  public var levels: StringMap<{u: Universe, m: HexMap}> = new StringMap<{u: Universe, m: HexMap}>();
  public var currentLevel: Int;


  public static function main() {
    hxd.Res.initEmbed();
    trace(-1.5 % 1);
    C.init();
    inst = new Manager();
  }
  
  override public function init () {
    var pass = new phi.Pass();

    addPass(pass);

    pass.add(new HexMapRule());
    pass.add(new rules.HexStructureRule());
    
    actors = new HexActorRule();

    pass.add(actors);
    pass.add(new rules.HeroRule());

    warpToLevel("Fortress 1");
  }

  public function warpToLevel (name: String) {
    var needsInit = false;
    var u: Universe = null;
    var m: HexMap = null;

    if (levels.get(name) == null) {
      needsInit = true;
      var s = new Scene();
      s.zoom = 4;
      s.x = 85 * 8/s.zoom;
      s.y = 45 * 8/s.zoom;
      u = new Universe(s);
      m = new HexMap(20);
      levels.set(name, {u: u, m: m});
    }
    
    this.map = levels.get(name).m;
    this.warpTo(levels.get(name).u);
    
    if (needsInit) {
      gen.Dungeon.make(u, m);
      trace(m);
    }
  }

  override public function tick () {
    super.tick();
    SimpleActuator.stage_onEnterFrame();
  }

  override public function render (e: Engine) {
    s2d.renderer.clear(0x080008);
    super.render(e);
  }
}