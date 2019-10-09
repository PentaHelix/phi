package archetypes;

import phi.Archetype;
import phi.Entity;
import h2d.Bitmap;
import traits.HexActorData;
import traits.HexTransform;

class Actor extends Archetype {
  @:trait
  public var transform: HexTransform;
  @:trait
  public var actor: HexActorData;

  public var sprite: Bitmap;
  public var entity: Entity;

  public static inline function moveTo (a: Actor, pos: HexVec): Bool {
    var map = Manager.inst.map;
    if (map.at(pos).actor != null) return false;

    map.at(a.transform.pos).actor = null;
    a.transform.pos = pos;
    map.at(a.transform.pos).actor = a;

    syncPosition(a);
    return true;
  }

  public static inline function syncPosition (a: Actor) {
    var p = a.transform.pos.toPixel();
    a.sprite.x = p.x;
    a.sprite.y = p.y - 5;
    a.transform.screenPos.x = a.sprite.x;
    a.transform.screenPos.y = a.sprite.y;
  }

  // public static function 
}