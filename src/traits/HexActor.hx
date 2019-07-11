package traits;

import phi.Trait;
import controllers.Controller;

class HexActor implements Trait {
  public var actorId: Int = 0;
  public var speed: Int = 50;
  public var energy: Int = 0;

  public var controller: Controller;

  public function new (actorId: Int, controller: Controller) {
    this.actorId = actorId;
    this.controller = controller;
  }
}