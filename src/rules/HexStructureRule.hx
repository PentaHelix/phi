package rules;

import phi.Game;
import hxd.Res;
import h2d.Tile;
import phi.Entity;
import h2d.Bitmap;
import traits.HexStructure;
import traits.HexTransform;
import phi.Rule;

typedef Structure = {
  @:trait var transform: HexTransform;
  @:trait var structure: HexStructure;
  var ?bitmap: Bitmap;
}

class HexStructureRule implements Rule<Structure> {
  private var tiles: Array<Array<Tile>>;
  public function new () {
    this.tiles = Res.load('structures.png').toTile().grid(16)
      .map(arr -> arr.map(t -> t.center()));
  }

  public function tick () {
    for (e in entities) {
      e.bitmap.tile = tiles[e.structure.structureId][e.structure.state];
    }
  }

  public function onMatched (s: Structure, e: Entity) {
    Manager.inst.map.at(s.transform.pos).structure = s.structure;
    s.structure.type.tile = Manager.inst.map.at(s.transform.pos).tile;
    s.structure.type.onPlace();

    var pos = s.transform.pos.toPixel();
    s.bitmap = new Bitmap(tiles[s.structure.structureId][0]);
    Game.universe.s2d.addChildAt(s.bitmap, 1);
    s.bitmap.setPosition(pos.x, pos.y);
  }
}