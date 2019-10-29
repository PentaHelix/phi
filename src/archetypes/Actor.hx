package archetypes;

import phi.Entity;
import h2d.Bitmap;
import traits.HexActorData;
import traits.HexTransform;

typedef Actor = {
  @:trait
  var transform: HexTransform;
  @:trait
  var actor: HexActorData;

  var ?sprite: Bitmap;
  var ?entity: Entity;
}