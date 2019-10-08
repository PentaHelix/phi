package traits;

import ds.DiceSet;
import phi.Trait;
import controllers.Controller;

class HexActorData implements Trait {
  public var actorId: Int = 0;

  public var name: String;
  public var facing: Int = 0;
  public var energy: Int = 0;

  public var baseAttack: DiceSet;

  public var health: Int;
  public var baseHealth: Int;

  public var speed: Int;
  public var strength: Int;
  public var perception: Int;

  public var controller: Controller;

  public function new (name: String, controller: Controller) {
    var data = C.actors.get(name);
    this.name = name;
    this.actorId = data.id;
    this.speed = data.speed;
    this.baseAttack = data.baseAttack;
    this.strength = data.strength;
    this.perception = data.perception;
    this.controller = controller;
    this.baseHealth = this.health = data.baseHealth;
  }
}