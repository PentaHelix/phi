package actions;

import traits.HexTransform;
import traits.HexActor;

class WalkAction implements Action {
  var actor: HexActor;
  var transform: HexTransform;
  var move: HexVec;
  var newFacing: Int;

  public function new (actor: HexActor, transform: HexTransform, move: HexVec, newFacing: Int) {
    this.actor = actor;
    this.transform = transform;
    this.move = move;
    this.newFacing = newFacing;
  }

  public function perform () {
    if (Game.map.at(transform.pos + move).tile == null) return false;
    if (!Game.map.at(transform.pos + move).tile.data.passable) return false;
    transform.pos += move;
    actor.facing = newFacing;
    return true;
  }
}