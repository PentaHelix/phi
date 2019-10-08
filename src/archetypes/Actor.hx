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
}