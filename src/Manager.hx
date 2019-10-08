package;

import rules.HexActorRule;
import traits.HexActorData;
import traits.HexTransform;
import phi.Entity;
import motion.actuators.SimpleActuator;
import haxe.ds.StringMap;
import h3d.Engine;
import phi.Universe;

import rules.HexMapRule;

class Manager extends phi.Game {
  public static var inst: Manager;

  public var hero: Entity;
  private var heroTransform: HexTransform;
  public var map: HexMap;
  public var actors: HexActorDataRule;
  public var levels: StringMap<{u: Universe, m: HexMap}> = new StringMap<{u: Universe, m: HexMap}>();
  public var currentLevel: Int;

  public static function main() {
    hxd.Res.initEmbed();
    C.init();
    inst = new Manager();
  }
  
  override public function init () {
    heroTransform = new HexTransform(HexVec.ZERO);
    hero = new Entity([
      heroTransform,
      new HexActorData("hero", new controllers.Hero()),
      new traits.Hero()
    ]);

    var pass = new phi.Pass();

    addPass(pass);

    pass.add(new HexMapRule());
    pass.add(new rules.HexStructureRule());
    
    actors = new HexActorDataRule();

    pass.add(actors);
    pass.add(new rules.HeroRule());

    warpToLevel("Fortress 1", "ladder_up");
    onResize();
  }

  public function warpToLevel (name: String, at: String) {
    var needsInit = false;

    if (levels.get(name) == null) {
      needsInit = true;
      var s = new scenes.LevelScene();
      s.onResize(s2d);
      levels.set(name, {
        u: new Universe(s),
        m: new HexMap(20)
      });
    }

    var m: HexMap = levels.get(name).m;
    var u: Universe = levels.get(name).u;
    
    this.map = m;
    this.warpTo(u);
    
    if (needsInit) {
      gen.Builder.build(name, u, m);
    }

    this.hero.warpTo(u);
    this.heroTransform.pos = map.poi.get(at);

    if (this.heroTransform.pos == null) {
      trace('Could not place hero!');
    }
  }

  override public function tick () {
    super.tick();
    SimpleActuator.stage_onEnterFrame();
    ui.UI.tick();
  }

  override public function render (e: Engine) {
    s2d.renderer.clear(0x080008);
    super.render(e);
  }

  override public function onResize () {
    ui.UI.get().onResize(s2d);
    phi.Game.universe.onResize();
  }
}