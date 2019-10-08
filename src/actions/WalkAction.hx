package actions;

import motion.easing.Expo;
import motion.easing.Quad;
import rules.HexActorRule;
import motion.Actuate;
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

    var p = self.transform.pos.toPixel();

    Actuate.tween(self.sprite, 0.2, {x: p.x, y: p.y - 5}).onUpdate(() -> {
      @:privateAccess self.sprite.posChanged = true;
      // TODO: find better alternative for screenPos
      self.transform.screenPos.x = self.sprite.x;
      self.transform.screenPos.y = self.sprite.y;
    }).ease(Quad.easeOut);
    return true;
  }
}