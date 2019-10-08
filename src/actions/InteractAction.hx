package actions;

import traits.HexStructure;
import archetypes.Actor;

class InteractAction implements Action {
  var self: Actor;
  var target: HexStructure;

  public function new (self: Actor, target: HexStructure) {
    this.self = self;
    this.target = target;
  }

  public function perform (): Bool {
    target.type.onInteract(self);
    return true;
  }
}