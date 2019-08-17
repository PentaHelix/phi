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
    var map = Manager.inst.map;
    
    if (map.at(self.transform.pos + move).tile == null) return false;

    if (!map.at(self.transform.pos + move).tile.passable) {
      if (map.at(self.transform.pos + move).structure != null) {
        var interaction = new InteractAction(self, map.at(self.transform.pos + move).structure);
        return interaction.perform();
      } else {
        return false;
      }
    }
    if (map.at(self.transform.pos + move).actor != null) {
      var attack = new AttackAction(self, map.at(self.transform.pos + move).actor);
      return attack.perform();
    }
    
    map.at(self.transform.pos).actor = null;
    self.transform.pos += move;
    map.at(self.transform.pos).actor = self;
    
    self.actor.facing = direction;
    return true;
  }
}