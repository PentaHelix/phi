package traits;

import phi.Trait;
import controllers.Controller;

class HexActor implements Trait {
  public var actorId: Int = 0;

  public var name: String;
  public var facing: Int = 0;
  public var energy: Int = 0;

  public var level: Int = 1;
  public var experience: Int = 0;

  // public var 
  public var speed: Int;

  public var controller: Controller;

  public function new (name: String, controller: Controller) {
    var data = C.actors.get(name);
    this.name = name;
    this.actorId = data.id;
    this.speed = data.speed;
    this.controller = controller;
  }
}