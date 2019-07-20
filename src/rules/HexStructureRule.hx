package rules;

import hxd.Res;
import h2d.Tile;
import h2d.Scene;
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
  private var s2d: Scene;
  private var tiles: Array<Array<Tile>>;
  public function new (s2d: Scene) {
    this.s2d = s2d;
    this.tiles = Res.load('structures.png').toTile().grid(16)
      .map(arr -> arr.map(t -> t.center()));
  }

  public function tick () {
    for (e in entities) {
      e.bitmap.tile = tiles[e.structure.structureId][e.structure.state];
    }
  }

  public function onMatched (s: Structure, e: Entity) {
    Manager.map.at(s.transform.pos).structure = s.structure;
    s.structure.type.tile = Manager.map.at(s.transform.pos).tile;
    s.structure.type.onPlace();
    var pos = s.transform.pos.toPixel();
    s.bitmap = new Bitmap(s2d);
    s.bitmap.tile = tiles[s.structure.structureId][0];
    s.bitmap.setPosition(pos.x, pos.y);
  }
}