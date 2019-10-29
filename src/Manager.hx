package;

import traits.HexStructure;
import structureTypes.Furniture;
import traits.Hero;
import archetypes.Actor;
import rules.ActorRule;
import traits.HexActorData;
import traits.HexTransform;
import phi.Entity;
import motion.actuators.SimpleActuator;
import haxe.ds.StringMap;
import h3d.Engine;
import phi.Universe;
import traits.HexMap;

import rules.HexMapRule;

using archetypes.Actor;
using phi.EntityTools;

class Manager extends phi.Game {
  public static var inst: Manager;

  public var hero: Entity;
  public var map: HexMap;
  public var actors: ActorRule;
  public var levels: StringMap<HexMap> = new StringMap<HexMap>();
  public var currentLevel: Int;

  public static function main() {
    hxd.Res.initEmbed();
    inst = new Manager();
  }
  
  override public function init () {
    C.init();
    var pass = new phi.Pass();
    var universe = new Universe(s2d);
    warpTo(universe);

    universe.addPass(pass);

    pass.add(new rules.HexStructureRule());    
    actors = new ActorRule();
    pass.add(actors);
    pass.add(new rules.HeroRule());


    buildLevel("Fortress 1");

    warpToLevel("Fortress 1", "ladder_up");
    onResize();

    // hero
    var hero = new Entity([
      new HexTransform(HexVec.ZERO),
      new HexActorData(map, 'hero', new controllers.Hero()),
      new Hero()
    ]);
}

  public function warpToLevel (name: String, at: String) {
    if (levels.get(name) == null) buildLevel(name);
    map = levels.get(name);

    // var m: HexMap = levels.get(name).m;
    // var u: Universe = levels.get(name).u;
    
    // this.map = m;
    // this.warpTo(u);
  
    // hero.get(HexActorData);
    // hero.moveTo(map.poi.get(at));
  }

  private function buildLevel (name: String) {
    var m: HexMap = new HexMap(20, phi.Game.universe.root);
    levels.set(name, m);
    map = m;
    gen.Builder.build(name, m);
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