package;

import traits.Hero;
import archetypes.Actor;
import rules.HexActorRule;
import traits.HexActorData;
import traits.HexTransform;
import phi.Entity;
import motion.actuators.SimpleActuator;
import haxe.ds.StringMap;
import h3d.Engine;
import phi.Universe;

import rules.HexMapRule;

using archetypes.Actor;
using phi.EntityTools;

class Manager extends phi.Game {
  public static var inst: Manager;

  public var hero: Actor;
  public var map: HexMap;
  public var actors: HexActorRule;
  public var levels: StringMap<{u: Universe, m: HexMap}> = new StringMap<{u: Universe, m: HexMap}>();
  public var currentLevel: Int;

  public static function main() {
    hxd.Res.initEmbed();
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

    buildLevel("Fortress 1");

    //hero
    var e = new Entity([
      new HexTransform(HexVec.ZERO),
      new HexActorData('hero', new controllers.Hero()),
      new Hero()
    ]);

    
    e.get(HexTransform);

    warpToLevel("Fortress 1", "ladder_up");
    onResize();
  }

  public function warpToLevel (name: String, at: String) {
    if (levels.get(name) == null) buildLevel(name);

    var m: HexMap = levels.get(name).m;
    var u: Universe = levels.get(name).u;
    
    this.map = m;
    this.warpTo(u);
  

    this.hero.entity.warpTo(u);
    this.hero.moveTo(map.poi.get(at));
  }

  private function buildLevel (name: String) {
    var s = new scenes.LevelScene();
    s.onResize(s2d);
    levels.set(name, {
      u: new Universe(s),
      m: new HexMap(20)
    });

    var m: HexMap = levels.get(name).m;
    var u: Universe = levels.get(name).u;

    this.map = m;
    phi.Game.universe = u;

    gen.Builder.build(name, u, m);
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