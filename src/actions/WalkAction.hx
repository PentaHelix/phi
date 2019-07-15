package actions;

import rules.HexActorRule.Actor;

class WalkAction implements Action {
  var self: Actor;
  var direction: Int;
  var move: HexVec;

  public function new (self: Actor, direction: Int) {
    this.self = self;
    this.direction = direction;
  }

  public function perform () {
    var move = HexVec.offsets[direction];
    if (Manager.map.at(self.transform.pos + move).tile == null) return false;
    if (!Manager.map.at(self.transform.pos + move).tile.data.passable) return false;
    if (Manager.map.at(self.transform.pos + move).actor != null) return false;
    
    Manager.map.at(self.transform.pos).actor = null;
    self.transform.pos += move;
    Manager.map.at(self.transform.pos).actor = self;
    
    self.actor.facing = direction;
    return true;
  }
}